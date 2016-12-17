defmodule Exjprop.Validators do

  @doc """
  Require a property
  """
  def required({:error, _error} = tuple), do: tuple
  def required({:ok, nil}), do: {:error, {nil, "cannot be nil"}}
  def required({:ok, _value} = tuple), do: tuple

  @doc """
  If the property is non-nil, parse it to an integer
  """
  def integer({:error, _error} = tuple), do: tuple
  def integer({:ok, nil} = tuple), do: tuple
  def integer({:ok, int} = tuple) when is_integer(int), do: tuple
  def integer({:ok, string}) when is_binary(string), do: handle_str_to_int(Integer.parse(string), string)
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

end
