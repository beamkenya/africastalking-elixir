defmodule AtEx.Gateway.Payments.Bank.TransferTest do
  @moduledoc false

  use ExUnit.Case
  alias AtEx.Gateway.Payments.Bank.Transfer

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              entries: [
                %{
                  accountNumber: "93892892",
                  status: "Queued",
                  transactionId: "ATPid_SampleTxnId",
                  transactionFee: "NGN 50.00"
                }
              ]
            })
        }
    end)

    :ok
  end

  describe "Bank Transfer" do
    test "bank_transfer/1 should initiate bank transfer  successfully" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
          amount: 1000.00,
          currencyCode: "KES",
          narration: "Payment",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:ok, result} = Transfer.bank_transfer(details)
      assert is_list(result["entries"])
    end

    test "bank_transfer/1 should fail without required params 'amount'" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
          currencyCode: "KES",
          narration: "Payment",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)

      assert "The request is missing required member 'amount'" = message
    end

    test "bank_transfer/1 should fail without required params 'currencyCode'" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
          amount: 1000.00,
          narration: "Payment",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)
      assert "The request is missing required member 'currencyCode'" = message
    end

    test "bank_transfer/1 should fail without required params 'narration'" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
          amount: 1000.00,
          currencyCode: "KES",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)

      assert "The request is missing required member 'narration'" = message
    end

    test "bank_transfer/1 should fail without required param 'metadata' is not a map" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234_001},
          amount: 1000.00,
          currencyCode: "KES",
          narration: "Payment",
          metadata: "fail"
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)
      assert "The required member 'metadata' must be a map" = message
    end

    test "bank_transfer/1 should fail without 'bankAccount' being map" do
      details = [
        %{
          bankAccount: "Here to fail",
          amount: 1000.00,
          currencyCode: "KES",
          narration: "Payment",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)
      assert "The required member 'bankAccount' must be a map" = message
    end

    test "bank_transfer/1 should fail when one of the required 'bankAccount' details missing" do
      details = [
        %{
          bankAccount: %{accountName: "KCB", bankCode: 234_001},
          amount: 1000.00,
          currencyCode: "KES",
          narration: "Payment",
          metadata: %{detail: "A Bill"}
        }
      ]

      {:error, message} = Transfer.bank_transfer(details)
      assert "The 'bankAccount' map is missing required member 'accountNumber'" = message
    end
  end
end
