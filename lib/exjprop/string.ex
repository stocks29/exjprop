defmodule Exjprop.String do
  
  @doc """
  Convert a string into a Stream
  """
  def to_stream(str) do
    Stream.unfold(str, &string_to_stream_unfolder/1)
  end

  defp string_to_stream_unfolder(acc) do 
    get_next_element_acc(String.length(acc), acc)
  end

  defp get_next_element_acc(0, _acc), do: nil
  defp get_next_element_acc(_length, acc) do
    case String.split(acc, "\n", parts: 2) do
      [element] -> {element, ""}
      [element, rest] -> {element, rest}
    end
  end
end