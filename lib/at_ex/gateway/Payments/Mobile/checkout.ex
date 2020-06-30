defmodule AtEx.Gateway.Payments.Mobile.Checkout do
  @moduledoc false

  # Using this system for delivery of which URL to use (sandbox or live)
  # determined by whether we are in production or development or test
  # Selection of the live URL can be forced by setting an environment
  # variable FORCE_AT_LIVE=YES
  url =
    if Mix.env() == :prod || System.get_env("FORCE_AT_LIVE") == "YES" do
      "https://payments.africastalking.com/mobile"
    else
      "https://payments.sandbox.africastalking.com/mobile"
    end

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: url, type: "json"

  @doc """
  This function initiates a mobile checkout request by sending a HTTP POST request to the Africa's talking Mobile Checkout endpoint.

  ## Parameters
  attrs: - a map containing a `phoneNumber`, `currencyCode` and `amount` key optionally it may also contain `providerChannel` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fcheckout for how to use these keys
  """
  @spec mobile_checkout(map()) :: {:ok, term()} | {:error, term()}
  def mobile_checkout(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :product_name)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:productName, product_name)

    "/checkout/request"
    |> post(params)
    |> process_result()
  end
end
