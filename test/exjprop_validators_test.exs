defmodule Exjprop.ValidatorsTest do
  use ExUnit.Case, async: true

  alias Exjprop.Validators, as: V

  test "boolean/1 does not modify errors" do
    assert V.boolean({:error, :foo}) == {:error, :foo}
  end

  test "boolean/1 handles true as true" do
    assert V.boolean({:ok, true}) == {:ok, true}
  end

  test "boolean/1 handles \"true\" as true" do
    assert V.boolean({:ok, "true"}) == {:ok, true}
  end

  test "boolean/1 handles \"false\" as false" do
    assert V.boolean({:ok, "false"}) == {:ok, false}
  end

  test "boolean/1 handles false as false" do
    assert V.boolean({:ok, false}) == {:ok, false}
  end

  test "boolean/1 handles \"\" as false" do
    assert V.boolean({:ok, ""}) == {:ok, false}
  end

  test "boolean/1 handles nil as false" do
    assert V.boolean({:ok, nil}) == {:ok, false}
  end

  test "keyword/1 does not modify errors" do
    assert V.keyword({:error, :foo}) == {:error, :foo}
  end

  test "keyword/1 handles maps" do
    assert V.keyword({:ok, ~s({"foo": "bar"})}) == {:ok, [foo: "bar"]}
  end

  test "keyword/1 handles lists of maps" do
    assert V.keyword({:ok, ~s([{"foo": "bar"}, {"baz": "quux"}])}) == {:ok, [foo: "bar", baz: "quux"]}
  end

  test "map/1 does not modify errors" do
    assert V.map({:error, :foo}) == {:error, :foo}
  end

  test "map/1 handles maps" do
    assert V.map({:ok, ~s({"foo": "bar"})}) == {:ok, %{foo: "bar"}}
  end

  test "map/1 handles lists of maps" do
    assert V.map({:ok, ~s([{"foo": "bar"}, {"baz": "quux"}])}) == {:ok, %{foo: "bar", baz: "quux"}}
  end
end
