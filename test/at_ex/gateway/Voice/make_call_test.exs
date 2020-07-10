defmodule AtEx.Gateway.Voice.MakeCallTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias AtEx.Gateway.Voice.MakeCall

  @attr "username="

  setup do
    mock(fn
      %{method: :post, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'from'"
        }

      %{method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "entries" => [
                %{
                  "phoneNumber" => "+254728907896",
                  "sessionId" => "ATVId_cb29c2b9fc27983827afc00786c4f9ea",
                  "status" => "Queued"
                }
              ],
              "errorMessage" => "None"
            })
        }
    end)

    :ok
  end

  describe "Voice Gateway" do
    test "call/1 should queue a call with required parameters" do
      call_details = %{from: "+254728833180", to: "+254728907896"}
      {:ok, result} = MakeCall.call(call_details)

      [msg] = result["entries"]
      assert msg["phoneNumber"] == call_details.to
      assert msg["status"] == "Queued"
    end

    test "call/1 should error out without from parameter" do
      {:error, result} = MakeCall.call(%{})
      "Request is missing required form field 'from'" = result.message

      400 = result.status
    end
  end
end
