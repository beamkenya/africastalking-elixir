defmodule AtEx.Gateway.Payments.Query.FetchWalletTransactions do
  @moduledoc """
  Fetch your wallet transactions by sending a HTTP GET request to the following endpoint
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/query"
  @sandbox_url "https://payments.sandbox.africastalking.com/query"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Fetch your wallet transactions by sending a HTTP GET request to the following endpoint

  ## Parameters
  attrs: - a map containing:
  - `pageNumber` - The number of the page you’d like to read results from. Please Note: This STARTS from `1` and NOT `0`
  - `count` - The number of transaction results you would like for this query. Must be `> 1` and `< 1,000`
  - and optional parameters `startDate`, `endDate`, `categories`, `provider`, `status`, `source`, `destination` and `providerChannel`
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffetch_wallet_transactions

  ## Example 
        iex>AtEx.Gateway.Payments.Query.FetchWalletTransactions.fetch_wallet_transactions(%{ pageNumber: 1, count: 10})
        {:ok,
        %{
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
        }}
  """

  @spec fetch_wallet_transactions(map()) :: {:ok, term()} | {:error, term()}
  def fetch_wallet_transactions(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    case validate_attrs(params) do
      {:ok} ->
        "/wallet/fetch"
        |> get(query: params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      Map.has_key?(attrs, :pageNumber) === false ->
        {:error, "The request is missing required member 'pageNumber'"}

      Map.has_key?(attrs, :count) === false ->
        {:error, "The request is missing required member 'count'"}

      true ->
        {:ok}
    end
  end
end
