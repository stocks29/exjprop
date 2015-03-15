defmodule Exjprop.Properties.File do
  defstruct prop_stream: nil

  alias Exjprop.Properties.Stream, as: PropStream

  @doc """
  Create a new file properties
  """
  def new(path) do
    prop_stream = path
    |> File.stream!
    |> PropStream.new
    %Exjprop.Properties.File{prop_stream: prop_stream}
  end

  @doc """
  Load the resource
  """
  def load(%Exjprop.Properties.File{prop_stream: prop_stream} = prop_file) do
    %{prop_file | prop_stream: PropStream.load(prop_stream)}
  end

  @doc """
  Returns true/false if the properties have been loaded
  """
  def loaded?(%Exjprop.Properties.File{prop_stream: prop_stream}) do 
    PropStream.loaded?(prop_stream)
  end

  @doc """
  Get the value of a property. Returns nil if the property does not exist.

  Raises an error if there is a problem fetching the property
  """
  def get_property!(%Exjprop.Properties.File{prop_stream: prop_stream}, property) do
    PropStream.get_property!(prop_stream, property)
  end

  @doc """
  Get the value of a property. See Exjprop.Properties.Stream for return values
  """
  def get_property(%Exjprop.Properties.File{prop_stream: prop_stream}, property) do
    PropStream.get_property(prop_stream, property)
  end

  @doc """
  Get a map of properties
  """
  def to_map(%Exjprop.Properties.File{prop_stream: prop_stream}) do
    Exjprop.Properties.to_map(prop_stream)
  end

  defimpl Exjprop.Properties, for: Exjprop.Properties.File do
    def get_property(props, property), do: Exjprop.Properties.File.get_property(props, property)
    def get_property!(props, property), do: Exjprop.Properties.File.get_property!(props, property)
    def load(props), do: Exjprop.Properties.File.load(props)
    def loaded?(props), do: Exjprop.Properties.File.loaded?(props)
    def to_map(props), do: Exjprop.Properties.File.to_map(props)
  end

end