defmodule AtEx.Gateway.Payments.Query.FetchWalletTransactionsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock

  doctest AtEx.Gateway.Payments.Query.FetchWalletTransactions
  alias AtEx.Gateway.Payments.Query.FetchWalletTransactions

  setup do
    mock(fn
      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "description" => "Success",
              "responses" => [
                %{
                  "balance" => "KES 90.0000",
                  "category" => "Debit",
                  "date" => "2020-07-13 13:46:08",
                  "description" => "MobileB2B Payment Request to Mine",
                  "transactionId" => "ATPid_2504d5f5d28256fa264e815518e3ab0d",
                  "value" => "KES 10.0000"
                },
                %{
                  "balance" => "KES 90.0000",
                  "category" => "Debit",
                  "date" => "2020-07-10 18:50:22",
                  "description" => "MobileB2C Payment Request to +254724540000",
                  "transactionId" => "ATPid_5e635fa1099b4c7f69e63a0cbc3120c4",
                  "value" => "KES 10.0000"
                },
                %{
                  "balance" => "KES 90.0000",
                  "category" => "Debit",
                  "date" => "2020-07-01 15:18:33",
                  "description" => "MobileB2C Payment Request to +254724540000",
                  "transactionId" => "ATPid_beeb0be6b1bff57ec8f32675fe3f6e72",
                  "value" => "KES 10.0000"
                }
              ],
              "status" => "Success"
            })
        }
    end)

    :ok
  end

  describe "Fetch Wallet Trasactions" do
    test "fetch_wallet_transactions/1 should find a particular wallet transaction" do
      {:ok, result} =
        FetchWalletTransactions.fetch_wallet_transactions(%{
          pageNumber: 1,
          count: 10
        })

      assert result["status"] == "Success"
      assert is_list(result["responses"])
    end

    test "fetch_wallet_transactions/1 should error out without 'pageNumber' parameter" do
      {:error, result} =
        FetchWalletTransactions.fetch_wallet_transactions(%{
          count: 10
        })

      "The request is missing required member 'pageNumber'" = result
    end

    test "fetch_wallet_transactions/1 should error out without 'count' parameter" do
      {:error, result} =
        FetchWalletTransactions.fetch_wallet_transactions(%{
          pageNumber: 1
        })

      "The request is missing required member 'count'" = result
    end
  end
end
