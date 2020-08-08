defmodule AtEx.Gateway.Payments.Bank.CheckoutTest do
  @moduledoc false

  use ExUnit.Case

  doctest AtEx.Gateway.Payments.Bank.Checkout
  alias AtEx.Gateway.Payments.Bank.Checkout

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "description" => "Payment is pending validation by the user",
              "status" => "PendingValidation",
              "transactionId" => "ATPid_0f4b78bf0926b4b05d131550f8fc4f2d"
            })
        }
    end)

    :ok
  end

  describe "Bank Checkout" do
    test "bank_checkout/1 should initiate bank checkout  successfully" do
      details = %{
        bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        metadata: %{detail: "A Bill"}
      }

      {:ok, result} = Checkout.bank_checkout(details)
      assert "PendingValidation" = result["status"]
    end

    test "bank_checkout/1 should fail without required params 'amount'" do
      details = %{
        bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
        currencyCode: "KES",
        narration: "Payment",
        metadata: %{detail: "A Bill"}
      }

      {:error, message} = Checkout.bank_checkout(details)

      assert "The request is missing required member 'amount'" = message
    end

    test "bank_checkout/1 should fail without required params 'currencyCode'" do
      details = %{
        bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
        amount: 1000.00,
        narration: "Payment",
        metadata: %{detail: "A Bill"}
      }

      {:error, message} = Checkout.bank_checkout(details)
      assert "The request is missing required member 'currencyCode'" = message
    end

    test "bank_checkout/1 should fail without required params 'narration'" do
      details = %{
        bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
        amount: 1000.00,
        currencyCode: "KES",
        metadata: %{detail: "A Bill"}
      }

      {:error, message} = Checkout.bank_checkout(details)

      assert "The request is missing required member 'narration'" = message
    end

    test "bank_checkout/1 should fail without required param 'metadata' is not a map" do
      details = %{
        bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        metadata: "fail"
      }

      {:error, message} = Checkout.bank_checkout(details)
      assert "The required member 'metadata' must be a map" = message
    end

    test "bank_checkout/1 should fail without 'bankAccount' being map" do
      details = %{
        bankAccount: "Here to fail",
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        metadata: %{detail: "A Bill"}
      }

      {:error, message} = Checkout.bank_checkout(details)
      assert "The required member 'bankAccount' must be a map" = message
    end

    test "bank_checkout/1 should fail when one of the required 'bankAccount' details missing" do
      details = %{
        bankAccount: %{accountName: "KCB", bankCode: 234_001},
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        metadata: %{detail: "A Bill"}
      }

      {:error, message} = Checkout.bank_checkout(details)
      assert "The 'bankAccount' map is missing required member 'accountNumber'" = message
    end
  end
end
