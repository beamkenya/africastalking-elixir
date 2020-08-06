defmodule AtEx.Gateway.Payments.Query.FetchProductTransactionsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock

  doctest AtEx.Gateway.Payments.Query.FetchProductTransactions
  alias AtEx.Gateway.Payments.Query.FetchProductTransactions

  setup do
    mock(fn
      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "status" => "Success",
              "responses" => %{
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

  describe "Fetch Products Trasactions" do
    test "fetch_product_transactions/1 should find a particular product transaction" do
      {:ok, result} =
        FetchProductTransactions.fetch_product_transactions(%{
          productName: "AtEx",
          pageNumber: 1,
          count: 10
        })

      assert result["status"] == "Success"
      assert is_map(result["responses"])
    end

    test "fetch_product_transactions/1 should error out without 'productName' parameter" do
      {:error, result} =
        FetchProductTransactions.fetch_product_transactions(%{
          pageNumber: 1,
          count: 10
        })

      "The request is missing required member 'productName'" = result
    end

    test "fetch_product_transactions/1 should error out without 'pageNumber' parameter" do
      {:error, result} =
        FetchProductTransactions.fetch_product_transactions(%{
          productName: "AtEx",
          count: 10
        })

      "The request is missing required member 'pageNumber'" = result
    end

    test "fetch_product_transactions/1 should error out without 'count' parameter" do
      {:error, result} =
        FetchProductTransactions.fetch_product_transactions(%{
          productName: "AtEx",
          pageNumber: 1
        })

      "The request is missing required member 'count'" = result
    end
  end
end
