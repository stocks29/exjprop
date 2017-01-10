defmodule Exjprop.Loader do
  require Logger

  @masked_value "*******"

  defmodule ValidationError do
    defexception message: "validation error", value: nil, is_secret: true

    def new(message, value, false = is_secret) do
      %ValidationError{message: "#{message} (#{inspect value})", value: value, is_secret: is_secret}
    end
    def new(message, _value, is_secret) do
      %ValidationError{message: message, value: "*******", is_secret: is_secret}
    end
  end

  defmacro __using__(_opts) do
    quote do
      require Logger
      import Exjprop.Loader, only: [property: 2, property: 3]

      @properties []

      @before_compile Exjprop.Loader

      @doc """
      Load properties from a URI (file:///..., s3:///...) or a function or stream
      """
      def load_properties(uri), do: Exjprop.Loader.load_properties(uri)

      @doc """
      Load properties from URI/fun/stream and load into application env
      """
      def load_and_update_env(nil) do
        Logger.warn "property file uri was nil"
      end
      def load_and_update_env("") do
        Logger.warn "property file uri was an empty string"
      end
      def load_and_update_env({:system, var}) do
        load_and_update_env(System.get_env(var))
      end
      def load_and_update_env(uri) do
        props = load_properties(uri)
        update_env(props)
        props
      end
    end
  end

  @doc """
  Define a property, including it's source key, and application env destination
  and options (including a pipeline)
  """
  defmacro property(source, key_path) do
    quote do
      @properties [{unquote(source), unquote(key_path), []} | @properties]
    end
  end

  defmacro property(source, key_path, opts) do
    quote do
      @properties [{unquote(source), unquote(key_path), unquote(opts)} | @properties]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def update_env(props) do
        Exjprop.Loader.update_env(@properties, props)
      end
    end
  end

  @doc """
  Given configured props and loaded props, update the application env
  """
  def update_env(configured_props, props) do
    Enum.each configured_props, fn {source, {app, module, key}, opts} ->
      is_secret = secret(opts)
      value = get_property!(props, source)
      |> process_pipeline!(opts[:pipeline], is_secret)
      handle_property_value(app, module, key, source, value, is_secret, opts)
    end
  end

  defp handle_property_value(_app, _module, _key, _source, nil, _is_secret, _opts) do
    # Not in properties file
    :ok
  end
  defp handle_property_value(app, module, key, source, value, is_secret, opts) do
    log_property_load(app, module, key, source, value, is_secret)
    update_env_key(app, module, key, value, opts)
  end

  defp log_property_load(app, module, key, source, value, false) do
    Logger.info ~s([Property] #{app} #{inspect module}.#{key} = ${"#{source}"} = "#{inspect value}")
  end
  defp log_property_load(app, module, key, source, _value, _is_secret) do
    Logger.info ~s([Property] #{app} #{inspect module}.#{key} = ${"#{source}"} = "#{@masked_value}")
  end

  @doc """
  Get a property
  """
  def get_property!(properties, prop) do
    Exjprop.Properties.get_property!(properties, prop)
  end

  defp process_pipeline!(value, nil, _is_secret), do: value
  defp process_pipeline!(value, funs, is_secret) do
    process_pipeline_steps({:ok, value}, funs)
    |> handle_pipeline_result(is_secret)
  end

  defp process_pipeline_steps(wrapped_val, []), do: wrapped_val
  defp process_pipeline_steps(wrapped_val, funs) do
    Enum.reduce(funs, wrapped_val, fn fun, acc ->
      fun.(acc)
    end)
  end

  defp handle_pipeline_result({:ok, value}, _is_secret), do: value
  defp handle_pipeline_result({:error, {value, message}}, is_secret), do: raise ValidationError.new(message, value, is_secret)

  @doc """
  Load the properties for the given uri/fun/stream
  """
  def load_properties(uri) do
    log_loading_message(uri)
    new_properties(uri)
    |> Exjprop.Properties.load
  end

  defp log_loading_message(uri) when is_binary(uri) do
    Logger.info("Loading properties from #{uri}")
  end
  defp log_loading_message(fun) when is_function(fun) do
    Logger.info("Loading properties from function")
  end
  defp log_loading_message(_stream) do
    Logger.info("Loading properties from a stream")
  end

  defp new_properties("file://" <> file) do
    Exjprop.Properties.File.new(file)
  end
  defp new_properties("s3:///" <> bucket_and_file) do
    [bucket, file] = String.split(bucket_and_file, "/", parts: 2)
    Exjprop.Properties.S3.new(bucket, file)
  end
  defp new_properties(fun) when is_function(fun) do
    Exjprop.Properties.Function.new(fun)
  end
  defp new_properties(stream) do
    Exjprop.Properties.Stream.new(stream)
  end

  defp update_env_key(_app, _key, _prop_key, nil, _opts) do
  end
  defp update_env_key(app, key, prop_key, value, _opts) do
    keywords = Application.get_env(app, key, [])
    |> Keyword.put(prop_key, value)
    Application.put_env(app, key, keywords, persistent: true)
  end

  defp secret(opts), do: nil_is_true(opts[:secret])

  defp nil_is_true(nil), do: true
  defp nil_is_true(other), do: other

end
