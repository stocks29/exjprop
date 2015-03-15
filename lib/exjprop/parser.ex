defmodule Exjprop.Parser do

  alias Exjprop.String, as: ExjString

  @doc """
  Parse an enumerable or multi-line string of properties into a map of keys 
  and values.

  If an enumerable is given, each enumberable entry should be a single 
  key=value entry.
  """
  def parse(string) when is_binary(string) do
    string
    |> ExjString.to_stream
    |> parse
  end
  def parse(enumerable) do
    Enum.reduce(enumerable, %{}, fn line, props_map ->
      append_prop(props_map, parse_line(line))
    end)
  end

  defp parse_line(nil), do: nil
  defp parse_line(""), do: nil
  defp parse_line("\n" <> _ = line), do: parse_line(String.strip(line))
  defp parse_line(" " <> _ = line), do: parse_line(String.strip(line))
  defp parse_line("#" <> _), do: nil
  defp parse_line(str), do: parse_key_val(String.strip(str))

  defp append_prop(props, nil), do: props
  defp append_prop(props, {key, value}), do: Map.put(props, key, value)
  
  defp parse_key_val(string) do
    [key, value] = String.split(string, "=", parts: 2)
    {key, empty_to_nil(value)}
  end

  defp empty_to_nil(""), do: nil
  defp empty_to_nil(str), do: str
end