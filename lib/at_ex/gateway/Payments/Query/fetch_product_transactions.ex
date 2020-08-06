defmodule AtEx.Gateway.Payments.Query.FetchProductTransactions do
  @moduledoc """
  Fetch transactions of a particular payment product by sending a HTTP GET request to the following endpoint
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/query"
  @sandbox_url "https://payments.sandbox.africastalking.com/query"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Fetch transactions of a particular payment product by sending a HTTP GET request to the following endpoint

  ## Parameters
  attrs: - a map containing:
  - `productName` - The name of the payment product whose transactions you’d like to fetch.
  - `pageNumber` - The number of the page you’d like to read results from. Please Note: This STARTS from `1` and NOT `0`
  - `count` - The number of transaction results you would like for this query. Must be `> 1` and `< 1,000`
  - and optional parameters `startDate`, `endDate`, `category`, `provider`, `status`, `source`, `destination` and `providerChannel`
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffetch_product_transactions

  ## Example 
        iex>AtEx.Gateway.Payments.Query.FetchProductTransactions.fetch_product_transactions(%{productName: "AtEx", pageNumber: 1, count: 10})
        {:ok,
        %{
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
        }}
  """

  @spec fetch_product_transactions(map()) :: {:ok, term()} | {:error, term()}
  def fetch_product_transactions(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    case validate_attrs(params) do
      {:ok} ->
        "/transaction/fetch"
        |> get(query: params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      Map.has_key?(attrs, :productName) === false ->
        {:error, "The request is missing required member 'productName'"}

      Map.has_key?(attrs, :pageNumber) === false ->
        {:error, "The request is missing required member 'pageNumber'"}

      Map.has_key?(attrs, :count) === false ->
        {:error, "The request is missing required member 'count'"}

      true ->
        {:ok}
    end
  end
end
