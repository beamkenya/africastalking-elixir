defmodule AtEx.Gateway.Payments.Bank.Validate do
  @moduledoc false
  import AtEx.Util

  @live_url "https://payments.africastalking.com/bank"
  @sandbox_url "https://payments.sandbox.africastalking.com/bank"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Bank checkout validation APIs allow your application to validate bank checkout charge requests.

  ## Parameters
  attrs: - a map containing `transactionId` and `otp` see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Fvalidate for how to use these keys

  ## Example 
    iex>AtEx.Gateway.Payments.Bank.Validate.bank_validate(%{transactionId: "63gvd6326t6732", otp: "password"})
    {:ok,
  %{
    "status": "Success",
    "description": "Payment completed successfully"
  }}
  """
  @spec bank_validate(map()) :: {:ok, term()} | {:error, term()}
  def bank_validate(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    case validate_attrs(params) do
      {:ok} ->
        "/checkout/validate"
        |> post(params)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_attrs(attrs) do
    cond do
      !Map.has_key?(attrs, :transactionId) ->
        {:error, "The request is missing required member 'transactionId'"}

      !Map.has_key?(attrs, :otp) ->
        {:error, "The request is missing required member 'otp'"}

      true ->
        {:ok}
    end
  end
end
