defmodule AtEx.Gateway.Payments.Query.FindTransactionTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Tesla.Mock

  doctest AtEx.Gateway.Payments.Query.FindTransaction
  alias AtEx.Gateway.Payments.Query.FindTransaction

  @attr "%{}"
  setup do
    mock(fn
      %{method: :get, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'transactionId'"
        }

      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "status" => "Success",
              "data" => %{
                "requestMetadata" => %{
                  "reason" => "Testing things..."
                },
                "sourceType" => "Wallet",
                "source" => "PaymentWallet",
                "provider" => "Mpesa",
                "destinationType" => "PhoneNumber",
                "description" => "The service request is processed successfully.",
                "providerChannel" => "824879",
                "transactionFee" => "KES 1.0000",
                "providerRefId" => "SAMPLE_MPESA_CODE",
                "providerMetadata" => %{
                  "recipientIsRegistered" => "true",
                  "recipientName" => "254724XXXYYY - John Doe"
                },
                "status" => "Success",
                "productName" => "testing",
                "category" => "MobileB2C",
                "transactionDate" => "12.05.2018 21:46:13",
                "destination" => "+254708663158",
                "value" => "KES 2900.0000",
                "transactionId" => "ATPid_b9379b671fee8ccf24b2c74f94da0ceb",
                "creationTime" => "2018-05-12 18:46:12"
              }
            })
        }
    end)

    :ok
  end

  describe "Find Trasaction" do
    test "find_transaction/1 should find a particular payment transaction" do
      {:ok, result} =
        FindTransaction.find_transaction(%{
          transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795"
        })

      assert result["status"] == "Success"
      assert is_map(result["data"])
    end

    test "find_transaction/1 should error out without 'transactionId' parameter" do
      {:error, result} = FindTransaction.find_transaction(%{})
      "Request is missing required form field 'transactionId'" = result.message

      400 = result.status
    end
  end
end
