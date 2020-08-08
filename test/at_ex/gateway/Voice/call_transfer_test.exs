defmodule AtEx.Gateway.Voice.CallTransferTest do
  @moduledoc """
  This module holds unit tests for the functions in Call Transfer
  """
  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest AtEx.Gateway.Voice.CallTransfer

  alias AtEx.Gateway.Voice.CallTransfer

  @attr "username="
  setup do
    mock(fn
      %{method: :post, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'sessionId'"
        }

      %{method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              callTransferResponse: %{
                status: "Success",
                errorMessage: "None"
              }
            })
        }
    end)

    :ok
  end

  describe "Call Transfer" do
    test "transfer/1 should queue a call with required parameters" do
      transfer_details = %{
        sessionId: "ATVId_cb29c2b9fc27983827afc00786c4f9ea",
        phoneNumber: "+254720000001"
      }

      {:ok, result} = CallTransfer.transfer(transfer_details)

      msg = result["callTransferResponse"]
      assert msg["status"] == "Success"
      assert msg["errorMessage"] == "None"
    end
  end

  test "status/1 should error out without from parameter" do
    {:error, result} = CallTransfer.transfer(%{})
    "Request is missing required form field 'sessionId'" = result.message

    400 = result.status
  end
end
