defmodule AtEx.Gateway.Payments.Mobile.B2bTest do
  @moduledoc false
  use ExUnit.Case
  alias AtEx.Gateway.Payments.Mobile.B2b

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "providerChannel" => "525900",
              "status" => "Queued",
              "transactionFee" => "KES 0.1000",
              "transactionId" => "ATPid_2504d5f5d28256fa264e815518e3ab0d"
            })
        }
    end)

    :ok
  end

  describe "Mobile Business To Business (B2B)" do
    test "b2b_checkout/1 should initiate B2B successfully" do
      details = %{
        provider: "Athena",
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:ok, result} = B2b.b2b_checkout(details)
      assert "Queued" = result["status"]
      assert "ATPid_2504d5f5d28256fa264e815518e3ab0d" = result["transactionId"]
    end

    test "b2b_checkout/1 should fail without required params 'phoneNumber'" do
      details = %{
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "The request is missing required member 'provider'" = message
    end

    test "b2b_checkout/1 should fail without required params 'amount'" do
      details = %{
        provider: "Athena",
        transferType: "DisburseFundsToBusiness",
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "The request is missing required member 'amount'" = message
    end

    test "b2b_checkout/1 should fail without required params 'currencyCode'" do
      details = %{
        provider: "Athena",
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "The request is missing required member 'currencyCode'" = message
    end

    test "b2b_checkout/1 should fail without required param 'metadata' is not a map" do
      details = %{
        provider: "Athena",
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: "I am here"
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "The request member 'metadata' is required and must be a map" = message
    end

    test "b2b_checkout/1 should fail without required param 'destinationChannel'" do
      details = %{
        provider: "Athena",
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        currencyCode: "KES",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "The request is missing required member 'destinationChannel'" = message
    end

    test "b2b_checkout/1 should fail without supported values for 'transferType'" do
      details = %{
        provider: "Athena",
        transferType: "WrongValue",
        amount: 10,
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)

      assert "Supported Transfer type at the moment are: BusinessBuyGoods, BusinessPayBill, DisburseFundsToBusiness, BusinessToBusinessTransfer" =
               message
    end

    test "b2b_checkout/1 should fail without supported values for 'provider'" do
      details = %{
        provider: "Test",
        transferType: "DisburseFundsToBusiness",
        amount: 10,
        currencyCode: "KES",
        destinationChannel: "Mine",
        destinationAccount: "Mine",
        metadata: %{message: "I am here"}
      }

      {:error, message} = B2b.b2b_checkout(details)
      assert "Supported providers at the moment are: Mpesa,TigoTanzania,Athena" = message
    end
  end
end
