defmodule AtEx.USSDTest do
  @moduledoc """
  This module holds unit tests for the functions in the USSD context
  use it to ensure the functions act consume inputs and produce the correct outputs
  """
  use ExUnit.Case
  alias AtEx.USSD

  @responses ["What would you want to check", "My Account", "My Phone number"]
  describe "USSD context" do
    test "responds with a con status if list is longer than one" do
      valid_resp = "CON What would you want to check\n1. My Account\n2. My Phone number"

      assert {:ok, valid_resp} == USSD.build_response(@responses)
    end

    test "responds with an end string if the input list is of size 1" do
      resp = ["my resp"]

      valid_resp = "END my resp"

      assert {:ok, valid_resp} == USSD.build_response(resp)
    end

    test "errors out if the list is empty" do
      assert {:error, _} = USSD.build_response([])
    end
  end
end
