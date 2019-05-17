defmodule AtEx.Gateway.Sms do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  SMS endpoint, use it to POST and GET requests to the SMS endpoint
  """
  use Tesla

  @accept Application.get_env(:at_ex, :accept)
  @key Application.get_env(:at_ex, :api_key)

  plug(Tesla.Middleware.BaseUrl, "https://api.sandbox.africastalking.com/version1")
  plug(Tesla.Middleware.FormUrlencoded)
  plug(Tesla.Middleware.Headers, [{"accept", @accept}, {"apikey", @key}])

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this 
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters 
  attrs: - a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
  link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys
  """
  @spec send_sms(map()) :: {:ok, term()} | {:error, term()}
  def send_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %{status: 201} = res} <- post("/messaging", params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
