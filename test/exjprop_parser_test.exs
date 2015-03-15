defmodule Exjprop.ParserTest do
  use ExUnit.Case, async: true

  alias Exjprop.Parser
  
  test "parser can parse multi-line/multi-entry strings" do

    str = """
    foo.bar=baz

    baz.quux=foo
        blah=bar

      # comment

         trailing.space=foo   

      with.equals=foo=bar
    """

    expected = %{
      "foo.bar" => "baz",
      "baz.quux" => "foo",
      "blah" => "bar",
      "trailing.space" => "foo",
      "with.equals" => "foo=bar",
    }

    assert Parser.parse(str) == expected
  end

  test "parser can parse enumerables of entries" do
    enum = [
      "foo=bar",
      "baz=quux",
    ]

    expected = %{
      "foo" => "bar",
      "baz" => "quux",
    }

    assert Parser.parse(enum) == expected
  end

end