defmodule AtEx.Gateway.Voice.QueueStatusTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case, async: true

  import Tesla.Mock

  doctest AtEx.Gateway.Voice.QueueStatus
  alias AtEx.Gateway.Voice.QueueStatus

  @attr "username="

  setup do
    mock(fn
      %{method: :post, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'phoneNumbers'"
        }

      %{method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "entries" => [
                %{
                  "phoneNumber" => "+254728833180",
                  "queueName" => "",
                  "numCalls" => 1
                },
                %{
                  "phoneNumber" => "+254728907896",
                  "queueName" => "",
                  "numCalls" => 4
                }
              ],
              "errorMessage" => "None",
              "status" => "Success"
            })
        }
    end)

    :ok
  end

  describe "Queue Status" do
    test "status/1 should queue a call with required parameters" do
      queue_details = %{phoneNumbers: "+254728833180,+254728907896"}
      {:ok, result} = QueueStatus.status(queue_details)

      msg = result["entries"]
      assert List.first(msg)["numCalls"] == 1
      assert result["status"] == "Success"
      assert result["errorMessage"] == "None"

      assert List.last(msg)["numCalls"] == 4
    end

    test "status/1 should error out without from parameter" do
      {:error, result} = QueueStatus.status(%{})
      "Request is missing required form field 'phoneNumbers'" = result.message

      400 = result.status
    end
  end
end
