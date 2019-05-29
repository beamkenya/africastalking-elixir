defmodule AtEx.Gateway.SmsTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case

  alias AtEx.Gateway.Sms

  @attr "username="

  setup do
    Tesla.Mock.mock(fn
      %{method: :post, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'to'"
        }

      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "SMSMessageData" => %{
                "Message" => "Sent to 1/1 Total Cost: ZAR 0.1124",
                "Recipients" => [
                  %{
                    "cost" => "KES 0.8000",
                    "messageId" => "ATXid_a584c3fd712a00b7bce3c4b7b552ac56",
                    "number" => "+254728833181",
                    "status" => "Success",
                    "statusCode" => 101
                  }
                ]
              }
            })
        }

      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "SMSMessageData" => %{
                "Messages" => [
                  %{
                    linkId: "SampleLinkId123",
                    text: "Hello",
                    to: "28901",
                    id: 15071,
                    date: "2018-03-19T08:34:18.445Z",
                    from: "+254711XXXYYY"
                  }
                ]
              }
            })
        }
    end)

    :ok
  end

  describe "Sms Gateway" do
    test "sends_sms/1 should send sms with required parameters" do
      # make message details
      send_details = %{to: "+254728833181", message: "new music"}

      # run details through our code
      {:ok, result} = Sms.send_sms(send_details)

      # assert our code gives us a single element list of messages
      [msg] = result["SMSMessageData"]["Recipients"]

      # assert that message details correspond to details of set up message
      assert msg["number"] == send_details.to
    end

    test "sends_sms/1 should error out without phone number parameter" do
      # run details through our code
      {:error, result} = Sms.send_sms(%{})

      "Request is missing required form field 'to'" = result.message

      400 = result.status
    end

    test "fetches sms collects data with correct params" do
      send_details = %{username: "sandbox"}

      # run details through our code
      {:ok, result} = Sms.fetch_sms(send_details)
      # assert our code gives us a single element list of messages
      [msg] = result["SMSMessageData"]["Messages"]

      # assert that message details correspond to details of set up message
      assert msg["text"] == "Hello"
    end

  end
end
