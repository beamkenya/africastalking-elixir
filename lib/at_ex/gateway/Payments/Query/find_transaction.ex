defmodule AtEx.Gateway.Payments.Query.FindTransaction do
  @moduledoc """
  Find a particular payment transaction by sending a HTTP GET request to the following endpoint:
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/query"
  @sandbox_url "https://payments.sandbox.africastalking.com/query"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Find a particular payment transaction by sending a HTTP GET request to the following endpoint:

  ## Parameters
  attrs: - a map containing:
  - `transactionId` - ID of the transaction you would like to find.
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffind_transaction

  ## Example 
        iex>AtEx.Gateway.Payments.Query.FindTransaction.find_transaction(%{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795"})
        {:ok,
        %{
        "status" => "Success",
        "data" => %{
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
  @spec find_transaction(map()) :: {:ok, term()} | {:error, term()}
  def find_transaction(%{transactionId: _id} = attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/transaction/find"
    |> get(query: params)
    |> process_result()
  end

  def find_transaction(_) do
    {:error, %{status: 400, message: "Request is missing required form fields 'transactionId'"}}
  end
end
