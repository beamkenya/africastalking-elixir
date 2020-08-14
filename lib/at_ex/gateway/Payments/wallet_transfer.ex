defmodule AtEx.Gateway.Payments.WalletTransfer do
  @moduledoc """
  This module implements the Wallet transfer Africas Talking API endpoint to
  allow a user to transfer money from one Payment Product to another Payment Product
  hosted on Africa’s Talking.
  """
  import AtEx.Util

  @live_url "https://payments.africastalking.com"
  @sandbox_url "https://payments.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Wallet transfer APIs allow you to transfer money from one Payment Product to another Payment Product
  hosted on Africa’s Talking.
  ## Parameters
  map: - a map containing:
  - `productName` Africa’s Talking Payment product to initiate this transaction.
  - `targetProductCode` Unique product code of the Africa’s Talking Payment Product to transfer the funds to.
  - `currencyCode`  3-digit ISO format currency code for the value of this transaction (e.g KES, UGX, USD)
  - `amount`  Amount - in the provided currency - that the application will be topped up with.
  - `metadata`  A map of any metadata that you would like us to associate with the request. Use this field to send data that will map notifications to topup stash requests. It will be included in the notification we send once the topup stash request is completed.

  ## Example

      iex> AtEx.Gateway.Payments.WalletTransfer.transfer(%{ currencyCode: "KES", amount: 1500.00, productName: "AtEx", targetProductCode: 564,  metadata: %{ message: "Electricity Bills"}})
      {:ok,
        %{
          "status" => "Success",
          "description" => "Transfered funds to sandbox [TestProduct]",
          "transactionId" => "ATPid_SampleTxnId123"
        }
      }
  """

  def transfer(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    case validate_attrs(params) do
      {:ok} ->
        "/transfer/wallet"
        |> post(params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      !Map.has_key?(attrs, :currencyCode) ->
        {:error, "The request is missing required member 'currencyCode'"}

      !Map.has_key?(attrs, :amount) ->
        {:error, "The request is missing required member 'amount'"}

      !Map.has_key?(attrs, :productName) ->
        {:error, "The request is missing required member 'productName'"}

      !Map.has_key?(attrs, :targetProductCode) ->
        {:error, "The request is missing required member 'targetProductCode'"}

      true ->
        {:ok}
    end
  end
end
