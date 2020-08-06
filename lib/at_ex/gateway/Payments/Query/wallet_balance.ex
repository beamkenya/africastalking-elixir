defmodule AtEx.Gateway.Payments.Query.WalletBalance do
  @moduledoc """
  Fetch your wallet balance by sending a HTTP GET request to the following endpoint
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/query"
  @sandbox_url "https://payments.sandbox.africastalking.com/query"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Find a particular payment transaction by sending a HTTP GET request to the following endpoint

  ## Example 
        iex>AtEx.Gateway.Payments.Query.WalletBalance.balance()
        {:ok, %{"balance" => "KES 90.0000", "status" => "Success"}}
  """
  @spec balance() :: {:ok, term()} | {:error, term()}
  def balance() do
    username = Application.get_env(:at_ex, :username)

    params =
      %{}
      |> Map.put(:username, username)

    "/wallet/balance"
    |> get(query: params)
    |> process_result()
  end
end
