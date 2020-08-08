defmodule AtEx.Gateway.Payments.TopupStashTest do
  @moduledoc false
  use ExUnit.Case
  doctest AtEx.Gateway.Payments.TopupStash
  alias AtEx.Gateway.Payments.TopupStash

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              status: "Success",
              description: "Topped up user stash. New Stash Balance: KES 1500.00",
              transactionId: "ATPid_SampleTxnId123"
            })
        }
    end)

    :ok
  end

  describe "Topup Stash is succesful" do
    test "topup/1 tops up a Topup stash" do
      details = %{
        currencyCode: "KES",
        amount: 10,
        productName: "AtEx",
        metadata: %{message: "I am here"}
      }

      {:ok, result} = TopupStash.topup(details)
      assert "Success" = result["status"]
    end

    test "topup/1 should fail without required param 'amount'" do
      details = %{
        currencyCode: "KES"
      }

      {:error, message} = TopupStash.topup(details)
      assert "The request is missing required member 'amount'" = message
    end

    test "topup/1 should fail without required param 'metadata'" do
      details = %{
        amount: 19
      }

      {:error, message} = TopupStash.topup(details)
      assert "The request is missing required member 'currencyCode'" = message
    end
  end
end
