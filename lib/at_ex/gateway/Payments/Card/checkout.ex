defmodule AtEx.Gateway.Payments.Card.Checkout do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Card Checkout API
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/card"
  @sandbox_url "https://payments.sandbox.africastalking.com/card"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Card Checkout APIs allow your application to collect money into your Payment Wallet by initiating transactions that deduct money from a customers Debit or Credit Card.

  ## Config
  Add `card_checkout_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a map containing `bankAccount`(a map), `currencyCode`, `amount`, `narration` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Fcheckout for how to use these keys

  ## Example 

        iex>AtEx.Gateway.Payments.Card.Checkout.card_checkout(%{amount: 1000.00, currencyCode: "KES", narration: "Payment", paymentCard: %{number: "10928873477387", cvvNumber: 253, expiryMonth: 12, expiryYear: 2020, countryCode: "NG", authToken: "jhdguyt6372gsu6q"}})
        {:ok, %{
              status: "PendingValidation",
              description: "Waiting for user input",
              transactionId: "ATPid_SampleTxnId123"
            }}
  """
  @spec card_checkout(map()) :: {:ok, term()} | {:error, term()}
  def card_checkout(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :card_checkout_product_name)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:productName, product_name)

    case validate_attrs(params) do
      {:ok} ->
        "/checkout/charge"
        |> post(params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      !Map.has_key?(attrs, :amount) ->
        {:error, "The request is missing required member 'amount'"}

      !Map.has_key?(attrs, :narration) ->
        {:error, "The request is missing required member 'narration'"}

      !Map.has_key?(attrs, :currencyCode) ->
        {:error, "The request is missing required member 'currencyCode'"}

      Map.has_key?(attrs, :metadata) && !is_map(attrs.metadata) ->
        {:error, "The optional member 'metadata' must be a map"}

      Map.has_key?(attrs, :paymentCard) && !is_map(attrs.paymentCard) ->
        {:error, "The optional member 'paymentCard' must be a map"}

      true ->
        {:ok}
    end
  end
end
