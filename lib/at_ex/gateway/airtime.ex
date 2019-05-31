defmodule AtEx.Gateway.Airtime do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  Application Data endpoint, use it to POST and GET requests to the Application endpoint
  """
  use AtEx.Gateway.Base

  @type send_input :: %{recipients: list(map())}
  @type call_return :: {:ok, term()} | {:error, term()}

  @doc """
  Collects application data from Africas Talking endpoint, Use this function to collect
  Data about your application

  ## Parameters
  * `none`

  ## Examples
      iex> AtEx.Airtime.send_airtime()
  """
  @spec send_airtime(send_input()) :: call_return()
  def send_airtime(%{recipients: people} = attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:recipients, Jason.encode!(people))

    with {:ok, %{status: 201} = res} <- post("/send", params),
         {:ok, %{"responses" => _} = res} <- process_result(res.body) do
      {:ok, res}
    else
      {:ok, %{status: st, body: b}} ->
        {:error, %{message: b, status: st}}

      {:ok, data} ->
        {:error, data}
    end
  end
end
