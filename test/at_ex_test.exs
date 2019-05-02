defmodule AtExTest do
  use ExUnit.Case
  doctest AtEx

  test "greets the world" do
    assert AtEx.hello() == :world
  end
end
