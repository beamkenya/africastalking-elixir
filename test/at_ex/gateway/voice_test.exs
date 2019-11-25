defmodule AtEx.Gateway.VoiceTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case

  alias AtEx.Gateway.Voice

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "entries" => [
                %{
                  "phoneNumber" => "+254728833181",
                  "sessionId" => "ATVId_f4eb2e8f8b4c26a30b86a4b4cf6bf7bb",
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
    test "make_a_call/1 should queue a call when required parameters are provided" do
      # make a call details
      call_details = %{from: "+254728833181", to: "+254780833181"}

      # run details through our code
      {:ok, result} = Voice.make_a_call(call_details)

      # assert our code gives us a single element list of message
      [msg] = result["entries"]

      # assert that message details correspond to details of set up message
      assert msg["status"] == "Queued"
    end
  end
end
