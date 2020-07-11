defmodule AtEx.Gateway.Airtime do
  import AtEx.Util

  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  Application Data endpoint, use it to POST and GET requests to the Application endpoint
  """
  @live_url "https://api.africastalking.com/version1/airtime"
  @sandbox_url "https://api.sandbox.africastalking.com/version1/airtime"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @type send_input :: %{recipients: list(map())}
  @type call_return :: {:ok, term()} | {:error, term()}

  @doc """
  Sends airtime to one or more numbers, accepts a map of parameters contaitning a list of maps each containing a
  phone numbers and an amount of airtime to send out to a number this is expected in the `recipients` key.

  ## Parameters
  * `map`: map containing a recipients which is a list of maps each with a phone number and amount

  ## Examples
      AtEx.Gateway.Airtime.send_airtime(%{recipients: [%{phone_number: +254721978097, amount: "KES 50"}]})
  """
  @spec send_airtime(send_input()) :: call_return()
  def send_airtime(%{recipients: people} = attrs) do
    username = Application.get_env(:at_ex, :username)

    serialized_people =
      people
      |> Enum.map(fn person -> serialize_person(person) end)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:recipients, Jason.encode!(serialized_people))

    with {:ok, %{status: 201} = res} <- post("/send", params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end

  @doc false
  defp serialize_person(%{phone_number: pn, amount: amt}),
    do: %{"phoneNumber" => pn, "amount" => amt}

  defp serialize_person(item),
    do: raise(ArgumentError, message: "recipient entry: #{inspect(item)} not valid")
end
