defmodule AtEx.Gateway.Sms.ParamTest do
  @moduledoc """
  This module holds unit tests for the `AtEx.Gateway.Sms.Param` module
  """
  use ExUnit.Case
  alias AtEx.Gateway.Sms.Param

  describe "harmonize/1" do
    test "requires both `:to` and `:message` to be given in the attributes for a success" do
      assert %{to: "0712356", message: "hello"} ==
               Param.harmonize(%{to: "0712356", message: "hello"})
    end
  end
end
