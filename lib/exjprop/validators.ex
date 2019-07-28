defmodule Exjprop.Validators do
  @doc """
  Require a property
  """
  def required({:error, _error} = tuple), do: tuple
  def required({:ok, nil}), do: {:error, {nil, "cannot be nil"}}
  def required({:ok, _value} = tuple), do: tuple

  def boolean({:error, _error} = tuple), do: tuple
  def boolean({:ok, ""}), do: {:ok, false}
  def boolean({:ok, nil}), do: {:ok, false}
  def boolean({:ok, true}), do: {:ok, true}
  def boolean({:ok, "true"}), do: {:ok, true}
  def boolean({:ok, false}), do: {:ok, false}
  def boolean({:ok, "false"}), do: {:ok, false}
  def boolean({:ok, value}), do: {:error, {value, "unexpected boolean value"}}

  @doc """
  If the property is non-nil, parse it to an integer
  """
  def integer({:error, _error} = tuple), do: tuple
  def integer({:ok, nil} = tuple), do: tuple
  def integer({:ok, int} = tuple) when is_integer(int), do: tuple

  def integer({:ok, string}) when is_binary(string),
    do: handle_str_to_int(Integer.parse(string), string)

  def integer({:ok, float}) when is_float(float), do: {:ok, trunc(float)}
  def integer({:ok, value}), do: {:error, value}

  @doc """
  If the property is non-nil, parse it to a float
  """
  def float({:error, _error} = tuple), do: tuple
  def float({:ok, nil} = tuple), do: tuple
  def float({:ok, int}) when is_integer(int), do: {:ok, int / 1}
  def float({:ok, string}) when is_binary(string), do: {:ok, String.to_float(string)}
  def float({:ok, value}), do: {:error, value}

  defp handle_str_to_int(:error, string), do: {:error, {string, "error parsing int"}}
  defp handle_str_to_int({int, _remainder}, _string), do: {:ok, int}

  if Code.ensure_loaded?(Jason) do

    @doc """
    If the property is non-nil, parse the given json string to a keyword list.
    Supports both js objects and lists of js objects.
    """
    def keyword({:error, _error} = tuple), do: tuple
    def keyword({:ok, nil}), do: {:ok, []}

    def keyword({:ok, json}) when is_binary(json) do
      case Jason.decode(json, keys: :atoms) do
        {:ok, map} when is_map(map) ->
          {:ok, Map.to_list(map)}

        {:ok, list} when is_list(list) ->
          Enum.reduce_while(list, {:ok, []}, fn
            item, {:ok, acc} when is_map(item) -> {:cont, {:ok, acc ++ Enum.into(item, [])}}
            _item, _acc -> {:halt, {:error, json}}
          end)

        {:ok, _other} ->
          {:error, json}

        {:error, _error} ->
          {:error, json}
      end
    end

    def keyword({:ok, value}), do: {:error, value}

    @doc """
    If the property is non-nil, parse the json string to a map.
    Supports both js objects and lists of js objects.
    """
    def map({:error, _error} = tuple), do: tuple
    def map({:ok, nil}), do: {:ok, %{}}

    def map({:ok, json}) when is_binary(json) do
      case Jason.decode(json, keys: :atoms) do
        {:ok, map} when is_map(map) ->
          {:ok, map}

        {:ok, list} when is_list(list) ->
          Enum.reduce_while(list, {:ok, %{}}, fn
            item, {:ok, acc} when is_map(item) -> {:cont, {:ok, Map.merge(acc, item)}}
            _item, _acc -> {:halt, {:error, json}}
          end)

        {:ok, _other} ->
          {:error, json}

        {:error, _error} ->
          {:error, json}
      end
    end

    def map({:ok, value}), do: {:error, value}
  end
end
