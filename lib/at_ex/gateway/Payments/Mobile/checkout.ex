defmodule AtEx.Gateway.Payments.Mobile.Checkout do
  @moduledoc false

  use AtEx.Gateway.Base

  @live_url "https://payments.africastalking.com/mobile/checkout/request"
  @sandbox_url "https://payments.sandbox.africastalking.com/mobile/checkout/request"

  # Using this system for delivery of which URL to use (sandbox or live)
  # determined by whether we are in production or development or test
  # Selection of the live URL can be forced by setting an environment
  # variable FORCE_AT_LIVE=YES
  defp get_url do
    cond do
      Mix.env() == :prod -> @live_url
      System.get_env("FORCE_AT_LIVE") == "YES" -> @live_url
      true -> @sandbox_url
    end
  end


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

    get_url()
    |> post(params)
    |> process_result()
  end
end
