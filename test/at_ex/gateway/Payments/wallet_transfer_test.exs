defmodule AtEx.Gateway.Payments.WalletTransferTest do
  @moduledoc false
  use ExUnit.Case
  doctest AtEx.Gateway.Payments.WalletTransfer
  alias AtEx.Gateway.Payments.WalletTransfer

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "status" => "Success",
              "description" => "Transfered funds to sandbox [TestProduct]",
              "transactionId" => "ATPid_SampleTxnId123"
            })
        }
    end)

    :ok
  end

  describe "Wallet Transfer" do
    test "transfer/1 tops up a Topup stash" do
      details = %{
        currencyCode: "KES",
        amount: 1500.00,
        productName: "AtEx",
        targetProductCode: 564,
        metadata: %{message: "Electricity Bills"}
      }

      {:ok, result} = WalletTransfer.transfer(details)
      assert "Success" = result["status"]
    end

    test "transfer/1 should fail without required param 'amount'" do
      details = %{
        currencyCode: "KES"
      }

      {:error, message} = WalletTransfer.transfer(details)
      assert "The request is missing required member 'amount'" = message
    end

    test "topup/1 should fail without required param 'metadata'" do
      details = %{
        amount: 19
      }

      {:error, message} = WalletTransfer.transfer(details)
      assert "The request is missing required member 'currencyCode'" = message
    end
  end
end
