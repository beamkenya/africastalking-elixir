defmodule AtEx.Gateway.AirtimeTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case
  doctest AtEx.Gateway.Airtime
  alias AtEx.Gateway.Airtime

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
              "errorMessage" => "None",
              "numSent" => 1,
              "responses" => [
                %{
                  "amount" => "KES 10.0000",
                  "discount" => "KES 0.4000",
                  "errorMessage" => "None",
                  "phoneNumber" => "+254728833158",
                  "requestId" => "ATQid_977712e28f36c37d5ce3b376f5f0168b",
                  "status" => "Sent"
                }
              ],
              "totalAmount" => "ZAR 1.4055",
              "totalDiscount" => "ZAR 0.0562"
            })
        }
    end)

    :ok
  end

  describe " Airtime Gateway" do
    test "sends_airtime/1 should send airtime to recipient" do
      # make message details
      send_details = %{recipients: [%{phone_number: "+254728833158", amount: "KES 10"}]}

      # run details through our code
      {:ok, result} = Airtime.send_airtime(send_details)

      # assert our code gives us a single element list of messages
      [msg] = result["responses"]

      # assert that message details correspond to details of set up message
      assert msg["amount"] == "KES 10.0000"
    end

    test "sends_airtime/1 should raise if recipient entry is invalid" do
      # make message details
      send_details = %{recipients: [%{"phoneNumber" => "+254728833158", "amount" => "KES 10"}]}

      assert_raise ArgumentError, fn ->
        Airtime.send_airtime(send_details)
      end
    end

    test "send_airtime/1 raise if the arguments doesn,t have the key recipient" do
      assert_raise ArgumentError, fn ->
        Airtime.send_airtime(%{})
      end
    end
  end
end
