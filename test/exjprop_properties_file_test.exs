defmodule Exjprop.Properties.FileTest do
  use ExUnit.Case, async: true
  alias Exjprop.Properties.File, as: FileProps

  @test_props_file "#{__DIR__}/test.properties"

  setup do
    props = FileProps.new(@test_props_file)
    {:ok, %{props: props}}
  end
  
  test "can load local props", %{props: props} do
    assert !FileProps.loaded?(props)
    props = FileProps.load(props)
    assert FileProps.loaded?(props)
  end

  test "can read a property after loading", %{props: props} do
    assert load_and_get_property(props, "foo.bar") == "baz"
  end

  test "can read a property with leading whitespace", %{props: props} do
    assert load_and_get_property(props, "some.prop") == "more"
  end

  test "can read a property with trailing whitespace", %{props: props} do
    assert load_and_get_property(props, "thing.with") == "trailing whitespace"
  end

  test "can read a property with no value", %{props: props} do
    assert load_and_get_property(props, "no.value") == nil
  end

  test "can read a non-existent property", %{props: props} do
    assert load_and_get_property(props, "does.not.exist") == nil
  end

  test "can read a property whose value has equal signs", %{props: props} do
    assert load_and_get_property(props, "value.with.equal") == "foo=bar=baz"
  end

  defp load_and_get_property(props, property) do
    FileProps.load(props)
    |> FileProps.get_property!(property)
  end
end