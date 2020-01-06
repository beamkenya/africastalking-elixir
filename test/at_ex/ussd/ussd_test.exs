defmodule AtEx.USSDTest do
  @moduledoc """
  This module holds unit tests for the functions in the USSD context
  use it to ensure the functions act consume inputs and produce the correct outputs
  """
  use ExUnit.Case
  alias AtEx.USSD
  doctest AtEx.USSD

  describe "build_response/2" do
    test "return tuple of :ok and message with content End to end the session" do
      {:ok, return_message} = USSD.build_response("good morning", :end)
      assert return_message == "END good morning"
    end

    test "given message and atom :cont, continues the session" do
      {:ok, return_message} = USSD.build_response("good morning", :cont)
      assert return_message == "CON good morning"
    end

    test "given the message, it continues with the session" do
      {:ok, return_message} = USSD.build_response("good morning")
      assert return_message == "CON good morning"
    end
  end

  describe "build_response/1" do
    test "errors out if the list is empty" do
      assert {:error, _} = USSD.build_response([])
    end
  end
end
