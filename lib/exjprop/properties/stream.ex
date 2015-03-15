defmodule Exjprop.Properties.Stream do
  defstruct stream: nil, prop_map_fun: &Map.new/0, loaded: false  

  alias Exjprop.Parser

  defmodule ResourceNotLoadedException do
    defexception [message: "The resource has not been loaded yet"]
  end

  defmodule PropertyRetrievalException do
    defexception [message: "There was an error retrieving the property"]
  end
  
  @doc """
  Create a new stream properties
  """
  def new(stream) do
    %Exjprop.Properties.Stream{stream: stream}
  end

  @doc """
  Load the resource
  """
  def load(%Exjprop.Properties.Stream{stream: stream} = stream_props) do
    props = Parser.parse(stream)

    # Actual loaded props are stored in a fn so they aren't accidentally logged
    # as part of the struct.
    %{stream_props | prop_map_fun: fn -> props end, loaded: true}
  end

  @doc """
  Returns true/false if the properties have been loaded
  """
  def loaded?(%Exjprop.Properties.Stream{loaded: loaded}), do: loaded

  @doc """
  Get the value of a property. Returns nil if the property does not exist.

  Raises a ResourceNotLoadedException if the file has not be loaded yet.
  """
  def get_property!(props, property) do
    case get_property(props, property) do
      {:ok, val} -> 
        val
      {:error, :not_loaded} -> 
        raise ResourceNotLoadedException, message: "The properties have not been loaded yet"
      {:error, error} -> 
        raise PropertyRetrievalException, message: "Error fetching properties: #{inspect error}"
    end
  end

  @doc """
  Returns `{:ok, value}` where value may be `nil` if the property is 
  empty or does not exist
  """
  def get_property(%Exjprop.Properties.Stream{loaded: false}, _property), do: {:error, :not_loaded}
  def get_property(%Exjprop.Properties.Stream{prop_map_fun: prop_map_fun}, property) do 
    {:ok, Map.get(prop_map_fun.(), property)}
  end

  @doc """
  Get the properties as a map
  """
  def to_map(%Exjprop.Properties.Stream{prop_map_fun: prop_map_fun}) do
    prop_map_fun.()
  end

  defimpl Exjprop.Properties, for: Exjprop.Properties.Stream do
    def get_property(props, property), do: Exjprop.Properties.Stream.get_property(props, property)
    def get_property!(props, property), do: Exjprop.Properties.Stream.get_property!(props, property)
    def load(props), do: Exjprop.Properties.Stream.load(props)
    def loaded?(props), do: Exjprop.Properties.Stream.loaded?(props)
    def to_map(props), do: Exjprop.Properties.Stream.to_map(props)
  end
end