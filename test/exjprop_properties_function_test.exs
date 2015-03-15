defmodule Exjprop.Properties.FunctionTest do
  use ExUnit.Case, async: true

  alias Exjprop.String, as: ExjString
  alias Exjprop.Properties.Function, as: PropFun
  
  test "can load properties from arbitrary function which returns stream" do
    props = PropFun.new(fn ->
      ExjString.to_stream("foo=bar\nbaz=quux")
    end)
    |> Exjprop.Properties.load

    expected = %{
      "foo" => "bar",
      "baz" => "quux"
    }

    assert Exjprop.Properties.to_map(props) == expected
  end
end
