defmodule Exjprop.Properties.Function do
  defstruct fun: nil, prop_stream: nil

  alias Exjprop.Properties.Stream, as: PropStream
  
  @doc """
  Create new function properties

  The passed in function must take no arguments and return a Stream
  """
  def new(fun) when is_function(fun) do
    %Exjprop.Properties.Function{fun: fun, prop_stream: PropStream.new(nil)}
  end

  @doc """
  Load the properties from the given function
  """
  def load(%Exjprop.Properties.Function{fun: fun} = prop_fun) do
    loaded_prop_stream = PropStream.new(fun.())
    |> PropStream.load
    %{prop_fun | prop_stream: loaded_prop_stream}
  end

  @doc """
  Determine if the properties have been loaded
  """
  def loaded?(prop_fun) do
    PropStream.loaded?(prop_fun.prop_stream)
  end

  @doc """
  Get a property, raising exceptions on error
  """
  def get_property!(prop_fun, property) do
    PropStream.get_property!(prop_fun.prop_stream, property)
  end

  @doc """
  Get a property
  """
  def get_property(prop_fun, property) do
    PropStream.get_property(prop_fun.prop_stream, property)
  end

  @doc """
  Get a map of properties
  """
  def to_map(prop_fun) do
    PropStream.to_map(prop_fun.prop_stream)
  end

  defimpl Exjprop.Properties, for: Exjprop.Properties.Function do
    def load(props), do: Exjprop.Properties.Function.load(props)
    def loaded?(props), do: Exjprop.Properties.Function.loaded?(props)
    def get_property!(props, property), do: Exjprop.Properties.Function.get_property!(props, property)
    def get_property(props, property), do: Exjprop.Properties.Function.get_property(props, property)
    def to_map(props), do: Exjprop.Properties.Function.to_map(props)
  end
end
