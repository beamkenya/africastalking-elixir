defmodule AtEx.Gateway.Payments.Mobile.B2b do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Mobile B2B API
  """
  import AtEx.Util

  @live_url "https://payments.africastalking.com/mobile"
  @sandbox_url "https://payments.sandbox.africastalking.com/mobile"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Mobile Business To Business (B2B) APIs allow you to send payments to businesses e.g banks from your Payment Wallet.

  ## Config
  Add `b2b_product_name` key to the AtEx config values

  ## Parameters
  attrs: - a map containing a `provider(Mpesa,TigoTanzania,Athena)`, `transferType(BusinessBuyGoods,BusinessPayBill, DisburseFundsToBusiness, BusinessToBusinessTransfer)`, `currencyCode` `amount`, `destinationChannel`, `destinationAccount` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fb2b for how to use these keys

  ## Example 
  
        iex>AtEx.Gateway.Payments.Mobile.B2b.b2b_checkout(%{provider: "Athena", transferType: "DisburseFundsToBusiness", amount: 10, currencyCode: "KES", destinationChannel: "Mine", destinationAccount: "Mine", metadata: %{ message: "I am here"}})
        {:ok,
    %{
    "providerChannel" => "525900",
    "status" => "Queued",
    "transactionFee" => "KES 0.1000",
    "transactionId" => "ATPid_2504d5f5d28256fa264e815518e3ab0d"
    }}
  """

  @spec b2b_checkout(map()) :: {:ok, term()} | {:error, term()}
  def b2b_checkout(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :b2b_product_name)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:productName, product_name)

    case validate_attrs(params) do
      {:ok} ->
        "/b2b/request"
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

      !Map.has_key?(attrs, :provider) ->
        {:error, "The request is missing required member 'provider'"}

      !Map.has_key?(attrs, :destinationChannel) ->
        {:error, "The request is missing required member 'destinationChannel'"}

      !Map.has_key?(attrs, :destinationAccount) ->
        {:error, "The request is missing required member 'destinationAccount'"}

      !Enum.member?(["Mpesa", "TigoTanzania", "Athena"], attrs.provider) ->
        {:error, "Supported providers at the moment are: Mpesa,TigoTanzania,Athena"}

      !Map.has_key?(attrs, :currencyCode) ->
        {:error, "The request is missing required member 'currencyCode'"}

      !Map.has_key?(attrs, :transferType) ->
        {:error, "The request is missing required member 'transferType'"}

      !Enum.member?(
        [
          "BusinessBuyGoods",
          "BusinessPayBill",
          "DisburseFundsToBusiness",
          "BusinessToBusinessTransfer"
        ],
        attrs.transferType
      ) ->
        {:error,
         "Supported Transfer type at the moment are: BusinessBuyGoods, BusinessPayBill, DisburseFundsToBusiness, BusinessToBusinessTransfer"}

      Map.has_key?(attrs, :metadata) && !is_map(attrs.metadata) ->
        {:error, "The request member 'metadata' is required and must be a map"}

      true ->
        {:ok}
    end
  end
end
