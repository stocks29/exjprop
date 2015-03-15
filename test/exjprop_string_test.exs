defmodule Exjprop.StringTest do
  use ExUnit.Case, async: true

  alias Exjprop.String, as: ExjString

  test "can convert string to stream" do
    str = """
    foo
    bar
    baz
    """

    assert Enum.join(ExjString.to_stream(str), ",") == "foo,bar,baz"
  end
end