defmodule Exjprop.Properties.S3 do
  defstruct prop_fun: nil

  alias Exjprop.Properties.Function, as: PropFun
  alias Exjprop.String, as: ExjString

  @doc """
  Create a new remote properties.

  Access and Secret key will be retrieved from ENV var or Metadata service
  """
  def new(bucket, key) do
    load_fun = fn ->
      get_s3_object_content_string(bucket, key)
      |> ExjString.to_stream
    end
    %Exjprop.Properties.S3{prop_fun: fn_to_prop_fun(load_fun)}
  end

  @doc """
  Load the properties form the remote resource
  """
  def load(%Exjprop.Properties.S3{prop_fun: prop_fun} = prop_s3) do
    %{prop_s3 | prop_fun: PropFun.load(prop_fun)}
  end

  @doc """
  Returns true/false if the properties have been loaded
  """
  def loaded?(%Exjprop.Properties.S3{prop_fun: prop_fun}) do
    PropFun.loaded?(prop_fun)
  end

  defp fn_to_prop_fun(fun) do
    PropFun.new(fun)
  end

  defp get_s3_object_content_string(bucket, key) do
    ExAws.S3.get_object(bucket, key)
    |> ExAws.request
    |> extract_s3_obj_content
  end

  defp extract_s3_obj_content({:ok, %{body: body}}) do
    body
  end

  defimpl Exjprop.Properties, for: Exjprop.Properties.S3 do
    def load(props), do: Exjprop.Properties.S3.load(props)
    def loaded?(props), do: Exjprop.Properties.S3.loaded?(props)
    def get_property!(props, property), do: Exjprop.Properties.Function.get_property!(props.prop_fun, property)
    def get_property(props, property), do: Exjprop.Properties.Function.get_property(props.prop_fun, property)
    def to_map(props), do: Exjprop.Properties.Function.to_map(props.prop_fun)
  end
end
