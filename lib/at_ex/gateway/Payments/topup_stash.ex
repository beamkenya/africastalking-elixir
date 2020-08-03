defmodule AtEx.Gateway.Payments.TopupStash do
  @moduledoc """
  This is the Topup stash module that implements APIs to allow you to move money
  from a Payment Product to an Africa’s Talking application stash.
  An application stash is the wallet that funds your service usage expences.
  """
  import AtEx.Util

  @live_url "https://payments.africastalking.com"
  @sandbox_url "https://payments.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Topup stash APIs allow you to move money from a Payment Product to an Africa’s Talking application stash.
  An application stash is the wallet that funds your service usage expences.

  ## Parameters
  map: - a map containing:
  - `productName` Africa’s Talking Payment product to initiate this transaction.
  - `currencyCode`  3-digit ISO format currency code for the value of this transaction (e.g KES, UGX, USD)
  - `amount`  Amount - in the provided currency - that the application will be topped up with.
  - `metadata`  A map of any metadata that you would like us to associate with the request. Use this field to send data that will map notifications to topup stash requests. It will be included in the notification we send once the topup stash request is completed.

  ## Example
      iex> AtEx.Gateway.Payments.TopupStash.topup(%{ currencyCode: "KES", amount: 1500, productName: "AtEx",  metadata: %{ message: "I am here"}})
      {:ok,
        %{
          "status" => "Success",
          "description" => "Topped up user stash. New Stash Balance: KES 1500.00",
          "transactionId" => "ATPid_SampleTxnId123"
        }
      }

  """

  def topup(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    case validate_attrs(params) do
      {:ok} ->
        "/topup/stash"
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

      true ->
        {:ok}
    end
  end
end
