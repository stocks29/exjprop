defmodule Exjprop.LoaderTest do
  use ExUnit.Case, async: true

  @test_props_file "#{__DIR__}/test.properties"

  defmodule TestModule do
    use Exjprop.Loader
    import Exjprop.Validators

    property "foo.bar", {:exjprop, Exjprop.Foo, :foo}, pipeline: [&required/1]
    property "foo.baz", {:exjprop, Exjprop.Foo, :quux}
    property "foo.quux", {:exjprop, Exjprop.Bar, :foo_quux}, pipeline: [&integer/1]
    property "bar.quux", {:exjprop, Exjprop.Bar, :bar_quux}, pipeline: [&float/1]
  end

  setup do
    Application.put_env(:exjprop, Exjprop.Foo, [])
    Application.put_env(:exjprop, Exjprop.Bar, [])
  end

  test "properties are loaded properly" do
    assert Application.get_env(:exjprop, Exjprop.Foo)[:foo] == nil
    assert Application.get_env(:exjprop, Exjprop.Foo)[:quux] == nil
    TestModule.load_and_update_env(["foo.bar=three","foo.baz=four"])
    assert Application.get_env(:exjprop, Exjprop.Foo)[:foo] == "three"
    assert Application.get_env(:exjprop, Exjprop.Foo)[:quux] == "four"
  end

  test "can load props without updating env" do
    props = TestModule.load_properties(["foo.bar=one","foo.baz=two"])
    assert Exjprop.Properties.get_property!(props, "foo.bar") == "one"
    assert Exjprop.Properties.get_property!(props, "foo.baz") == "two"
  end

  test "should raise when required property not provided and updating env" do
    assert_raise(Exjprop.Loader.ValidationError, fn ->
      TestModule.load_and_update_env(["foo.baz=two"])
    end)
  end

  test "properties are loaded properly and transformed via pipeline" do
    assert Application.get_env(:exjprop, Exjprop.Foo)[:foo_quux] == nil
    assert Application.get_env(:exjprop, Exjprop.Foo)[:bar_quux] == nil
    TestModule.load_and_update_env(["foo.bar=one","foo.quux=1","bar.quux=2.47"])
    assert Application.get_env(:exjprop, Exjprop.Bar)[:foo_quux] == 1
    assert Application.get_env(:exjprop, Exjprop.Bar)[:bar_quux] == 2.47
  end

  test "can load property using env var with uri" do
    env = "MYFILE"
    System.put_env(env, "file:///#{@test_props_file}")
    TestModule.load_and_update_env({:system, env})
    assert Application.get_env(:exjprop, Exjprop.Foo)[:foo] == "baz"
  end
end
