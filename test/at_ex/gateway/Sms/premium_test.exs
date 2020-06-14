defmodule AtEx.Gateway.SmsTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case

  alias AtEx.Gateway.Sms.PremiumSubscriptions

  @attr "username="

  # Endpoint for getting the checkout token
  # Unless overridden, we will always use the sandbox URL during test
  # If overridden, all the checkout token tests will fail.
  @checkout_token_url "https://api.sandbox.africastalking.com/checkout/token/create"

  # Values needed for checkout token tests
  @checkout_token_phonenumber "+254728833181"
  @checkout_token_query URI.encode_query(%{phoneNumber: @checkout_token_phonenumber})
  @checkout_token "CkTkn_SampleCkTknId123"

  @subscription_url "https://api.sandbox.africastalking.com/version1/subscription"

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

  describe "Sms Gateway/Premium" do
    # Checkout token tests need their own mock calls, or we would need
    # separate phone numbers for each test.  This way values can be
    # reused.
    test "fetch checkout token successfully" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Success",
                "token" => @checkout_token
              })
          }
      end)

      assert {:ok, token} =
               PremiumSubscriptions.generate_checkout_token(@checkout_token_phonenumber)

      assert token == @checkout_token
    end

    test "fetch checkout token failure token: none" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Error Message",
                "token" => "None"
              })
          }
      end)

      assert {:error, message} =
               PremiumSubscriptions.generate_checkout_token(@checkout_token_phonenumber)

      assert message == "Failure - Error Message"
    end

    test "fetch checkout token failure status code" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 500,
            body: "Failure message"
          }
      end)

      assert {:error, message} =
               PremiumSubscriptions.generate_checkout_token(@checkout_token_phonenumber)

      assert message = "500 - Error Message"
    end

    test "fetch checkout token failure description: Failure" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Failure",
                "token" => "Potential Error Message"
              })
          }
      end)

      assert {:error, message} =
               PremiumSubscriptions.generate_checkout_token(@checkout_token_phonenumber)

      assert message == "Failure - Potential Error Message"
    end

    test "create subscription success" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Success",
                "token" => @checkout_token
              })
          }

        %{method: :post, url: @subscription_url <> "/create"} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Waiting for user input",
                "status" => "Success"
              })
          }
      end)

      assert {:ok, response} =
               PremiumSubscriptions.create_subscription(%{
                 phoneNumber: @checkout_token_phonenumber,
                 shortCode: "12345",
                 keyword: "music"
               })

      assert response["status"] == "Success"
    end

    test "create subscription failure - invalid shortCode" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @checkout_token_url, body: @checkout_token_query} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Success",
                "token" => @checkout_token
              })
          }

        %{method: :post, url: @subscription_url <> "/create"} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                "description" => "Please ensure 99999 is configured under your API account",
                "status" => "Failed"
              })
          }
      end)

      assert {:ok, response} =
               PremiumSubscriptions.create_subscription(%{
                 phoneNumber: @checkout_token_phonenumber,
                 shortCode: "99999",
                 keyword: "music"
               })

      assert response["status"] == "Failed"
    end

    test "list subscriptions success" do
      Tesla.Mock.mock(fn
        %{method: :get, url: @subscription_url} ->
          %Tesla.Env{
            status: 200,
            body:
              Jason.encode!(%{
                "responses" => [
                  %{
                    "date" => "2019-10-05T18:57:08.000",
                    "id" => 2_007_800,
                    "phoneNumber" => "+254711123123",
                    "shortCode" => "12345",
                    "keyword" => "music"
                  }
                ]
              })
          }
      end)

      assert {:ok, response} = PremiumSubscriptions.fetch_subscriptions()

      assert Enum.count(response["responses"]) == 1
    end

    test "list subscriptions failure" do
      Tesla.Mock.mock(fn
        %{method: :get, url: @subscription_url} ->
          %Tesla.Env{
            status: 404,
            body: "Request is missing required query parameter 'shortCode'"
          }
      end)

      assert {:error, response} = PremiumSubscriptions.fetch_subscriptions()

      assert response.message == "Request is missing required query parameter 'shortCode'"
    end

    test "delete subscription success" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @subscription_url <> "/delete"} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                status: "Success",
                description: "Succeeded"
              })
          }
      end)

      assert {:ok, response} =
               PremiumSubscriptions.delete_subscription(%{
                 phoneNumber: @checkout_token_phonenumber,
                 shortCode: "12345",
                 keyword: "music"
               })

      assert response["description"] == "Succeeded"
      assert response["status"] == "Success"
    end

    test "delete subscription failure" do
      Tesla.Mock.mock(fn
        %{method: :post, url: @subscription_url <> "/delete"} ->
          %Tesla.Env{
            status: 201,
            body:
              Jason.encode!(%{
                description: "Please ensure 99900 is configured under your API account",
                status: "Failed"
              })
          }
      end)

      assert {:ok, response} =
               PremiumSubscriptions.delete_subscription(%{
                 phoneNumber: @checkout_token_phonenumber,
                 shortCode: "99900",
                 keyword: "music"
               })

      assert response["status"] == "Failed"
    end
  end
end
