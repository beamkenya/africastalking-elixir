defmodule AtEx.Gateway.Payments.Bank.Transfer do
  @moduledoc false
  import AtEx.Util

  @live_url "https://payments.africastalking.com/bank"
  @sandbox_url "https://payments.sandbox.africastalking.com/bank"

  # The `type` config is to allow the api send `application/json` check https://github.com/teamon/tesla#formats for more info

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  Bank checkout validation APIs allow your application to validate bank checkout charge requests.

  ## Config
  add `bank_transfer_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a list of recipients each containing a map with `currencyCode`, `amount`, `narration` and a map of `metadata` (optional) see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Ftransfer for how to use these keys

  ## Example 
    iex>AtEx.Gateway.Payments.Bank.Transfer.bank_transfer([%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}}])
    
    {:ok,
  %{
     "entries": [%{
        "accountNumber": "93892892",
        "status": "Queued",
        "transactionId": "ATPid_SampleTxnId",
        "transactionFee": "NGN 50.00"
    }]
  }}
  """
  @spec bank_transfer(list()) :: {:ok, term()} | {:error, term()}
  def bank_transfer(attrs) when is_list(attrs) do
    username = Application.get_env(:at_ex, :username)
    product_name = Application.get_env(:at_ex, :bank_transfer_product_name)

    case validate_attrs(attrs) do
      %{ok: _} ->
        params =
          %{recipients: attrs}
          |> Map.put(:username, username)
          |> Map.put(:productName, product_name)

        "/transfer"
        |> post(params)
        |> process_result()

      %{error: message} ->
        {:error, message}
    end
  end

  def bank_transfer(list) when not is_list(list),
    do: {:error, "The requst body should be a list of a map of recipients"}

  defp validate_attrs(attrs) do
    case Enum.all?(attrs, &is_map(&1)) do
      true ->
        for param <- attrs, into: %{} do
          cond do
            !Map.has_key?(param, :amount) ->
              {:error, "The request is missing required member 'amount'"}

            !Map.has_key?(param, :narration) ->
              {:error, "The request is missing required member 'narration'"}

            !Map.has_key?(param, :currencyCode) ->
              {:error, "The request is missing required member 'currencyCode'"}

            !Map.has_key?(param, :metadata) || !is_map(param.metadata) ->
              {:error, "The required member 'metadata' must be a map"}

            !Map.has_key?(param, :bankAccount) || !is_map(param.bankAccount) ->
              {:error, "The required member 'bankAccount' must be a map"}

            is_map(param.bankAccount) && !Map.has_key?(param.bankAccount, :accountName) ->
              {:error, "The 'bankAccount' map is missing required member 'accountName'"}

            is_map(param.bankAccount) && !Map.has_key?(param.bankAccount, :accountNumber) ->
              {:error, "The 'bankAccount' map is missing required member 'accountNumber'"}

            is_map(param.bankAccount) and !Map.has_key?(param.bankAccount, :bankCode) ->
              {:error, "The 'bankAccount' map is missing required member 'bankCode'"}

            is_map(param.bankAccount) and param.bankAccount.bankCode === 234_002 and
                !Map.has_key?(attrs.bankAccount, :dateOfBirth) ->
              {:error,
               "The 'bankAccount' map is missing optional member 'dateOfBirth' required for this bank"}

            true ->
              {:ok, "success"}
          end
        end

      false ->
        %{error: "The requst body should be a list of map"}
    end
  end
end
