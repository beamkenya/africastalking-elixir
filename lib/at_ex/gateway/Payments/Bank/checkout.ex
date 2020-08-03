defmodule AtEx.Gateway.Payments.Bank.Checkout do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Bank Checkout API
  """
  import AtEx.Util

  @live_url "https://payments.africastalking.com/bank"
  @sandbox_url "https://payments.sandbox.africastalking.com/bank"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Bank checkout APIs allow your application to collect money into your payment wallet by initiating transactions that deduct money from a customers bank account.

  ## Config
  add `bank_checkout_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a map containing `bankAccount`(a map), `currencyCode`, `amount`, `narration` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Fcheckout for how to use these keys

  ## Example 

        iex>AtEx.Gateway.Payments.Bank.Checkout.bank_checkout(%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}})
        {:ok,
        %{
        "description" => "Payment is pending validation by the user",
        "status" => "PendingValidation",
        "transactionId" => "ATPid_0f4b78bf0926b4b05d131550f8fc4f2d"
        }}
  """
  @spec bank_checkout(map()) :: {:ok, term()} | {:error, term()}
  def bank_checkout(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :bank_checkout_product_name)

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

      !Map.has_key?(attrs, :metadata) || !is_map(attrs.metadata) ->
        {:error, "The required member 'metadata' must be a map"}

      !Map.has_key?(attrs, :bankAccount) || !is_map(attrs.bankAccount) ->
        {:error, "The required member 'bankAccount' must be a map"}

      is_map(attrs.bankAccount) && !Map.has_key?(attrs.bankAccount, :accountName) ->
        {:error, "The 'bankAccount' map is missing required member 'accountName'"}

      is_map(attrs.bankAccount) && !Map.has_key?(attrs.bankAccount, :accountNumber) ->
        {:error, "The 'bankAccount' map is missing required member 'accountNumber'"}

      is_map(attrs.bankAccount) and !Map.has_key?(attrs.bankAccount, :bankCode) ->
        {:error, "The 'bankAccount' map is missing required member 'bankCode'"}

      is_map(attrs.bankAccount) and attrs.bankAccount.bankCode === 234_002 and
          !Map.has_key?(attrs.bankAccount, :dateOfBirth) ->
        {:error,
         "The 'bankAccount' map is missing optional member 'dateOfBirth' required for this bank"}

      true ->
        {:ok}
    end
  end
end
