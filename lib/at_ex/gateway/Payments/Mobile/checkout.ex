defmodule AtEx.Gateway.Payments.Mobile.Checkout do
  @moduledoc false
  import AtEx.Util

  @live_url "https://payments.africastalking.com/mobile"
  @sandbox_url "https://payments.sandbox.africastalking.com/mobile"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  This function initiates a mobile checkout request by sending a HTTP POST request to the Africa's talking Mobile Checkout endpoint.

  ## Parameters
  attrs: - a map containing a `phoneNumber`, `currencyCode` and `amount` key optionally it may also contain `providerChannel` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fcheckout for how to use these keys

  ## Example 
    iex>AtEx.Gateway.Payments.Mobile.Checkout.mobile_checkout(%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES"})
    %{:ok,
        %{
        "description" => "Waiting for user input",
        "providerChannel" => "525900",
        "status" => "PendingConfirmation",
        "transactionId" => "ATPid_bbd0bcd713e27d9201807076c6db0ed5"
        }
    }
  """
  @spec mobile_checkout(map()) :: {:ok, term()} | {:error, term()}
  def mobile_checkout(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :stk_product_name)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:productName, product_name)

    case validate_attrs(params) do
      {:ok} ->
        "/checkout/request"
        |> post(params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      Map.has_key?(attrs, :amount) === false ->
        {:error, "The request is missing required member 'amount'"}

      Map.has_key?(attrs, :phoneNumber) === false ->
        {:error, "The request is missing required member 'phoneNumber'"}

      Map.has_key?(attrs, :currencyCode) === false ->
        {:error, "The request is missing required member 'currencyCode'"}

      Map.has_key?(attrs, :providerChannel) && is_bitstring(attrs.providerChannel) === false ->
        {:error, "The optional member 'providerChannel' must be a string"}

      Map.has_key?(attrs, :metadata) && is_map(attrs.metadata) === false ->
        {:error, "The optional member 'metadata' must be a map"}

      true ->
        {:ok}
    end
  end
end
