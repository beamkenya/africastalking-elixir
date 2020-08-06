defmodule AtEx.Gateway.Payments.Query.WalletBalanceTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock

  doctest AtEx.Gateway.Payments.Query.WalletBalance
  alias AtEx.Gateway.Payments.Query.WalletBalance

  setup do
    mock(fn
      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body: Jason.encode!(%{"balance" => "KES 90.0000", "status" => "Success"})
        }
    end)

    :ok
  end

  describe "Wallet balance" do
    test "balance/1 should find a wallet balance" do
      {:ok, result} = WalletBalance.balance()

      assert result["status"] == "Success"
      assert result["balance"] == "KES 90.0000"
    end
  end
end
