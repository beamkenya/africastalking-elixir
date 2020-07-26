defmodule AtEx.Gateway.Payments.Mobile.B2c do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Mobile B2C API
  """

  import AtEx.Util

  @live_url "https://payments.africastalking.com/mobile"
  @sandbox_url "https://payments.sandbox.africastalking.com/mobile"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  This function initiates a mobile B2C request by making a HTTP POST request to the Africa's talking Mobile B2C endpoint.

  ## Config
  Add `b2c_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a list of Recipient each a map containing a `phoneNumber`, `currencyCode`, `amount` and a map of `metadata` key optionally it may also contain `name`, `reason` and `providerChannel` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fb2c%2Foverview for how to use these keys

  ## Example 
        iex>AtEx.Gateway.Payments.Mobile.B2c.b2c_checkout([%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES", metadata: %{ message: "I am here"}}])
        {:ok,
        %{
        "entries" => [
            %{
            "phoneNumber" => "+254724540000",
            "provider" => "Athena",
            "providerChannel" => "525900",
            "status" => "Queued",
            "transactionFee" => "KES 0.1000",
            "transactionId" => "ATPid_2b76da39eebd5c6bcc49e5d30c3d0390",
            "value" => "KES 10.0000"
            }
        ],
        "numQueued" => 1,
        "totalTransactionFee" => "KES 0.1000",
        "totalValue" => "KES 10.0000"
        }}
  """
  @spec b2c_checkout(list()) :: {:ok, term()} | {:error, term()}
  def b2c_checkout(attrs) when is_list(attrs) and length(attrs) <= 10 do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :b2c_product_name)

    case validate_attrs(attrs) do
      %{ok: _} ->
        params =
          %{recipients: attrs}
          |> Map.put(:username, username)
          |> Map.put(:productName, product_name)

        "/b2c/request"
        |> post(params)
        |> process_result()

      %{error: message} ->
        {:error, message}
    end
  end

  def b2c_checkout(attrs) when is_list(attrs) and length(attrs) > 10,
    do: {:error, "Too many phone numbers in the request (maximum is 10)"}

  def b2c_checkout(list) when not is_list(list),
    do: {:error, "The request body should be a list of a map of recipients"}

  defp validate_attrs(attrs) do
    case Enum.all?(attrs, &is_map(&1)) do
      true ->
        for param <- attrs, into: %{} do
          cond do
            Map.has_key?(param, :amount) === false ->
              {:error, "The request is missing required member 'amount' in one of the recipients"}

            Map.has_key?(param, :phoneNumber) === false ->
              {:error,
               "The request is missing required member 'phoneNumber' in one of the recipients"}

            Map.has_key?(param, :currencyCode) === false ->
              {:error,
               "The request is missing required member 'currencyCode' in one of the recipients"}

            Map.has_key?(param, :providerChannel) && is_bitstring(param.providerChannel) === false ->
              {:error,
               "The optional member 'providerChannel' must be a string in one of the recipients"}

            Map.has_key?(param, :metadata) && is_map(param.metadata) === false ->
              {:error, "The required member 'metadata' must be a map in one of the recipients"}

            true ->
              {:ok, "success"}
          end
        end

      false ->
        %{error: "The requst body should be a list of map"}
    end
  end
end
