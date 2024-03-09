defmodule AtEx.Gateway.Application do
  import AtEx.Util

  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  Application Data endpoint, use it to POST and GET requests to the Application endpoint
  """
  @live_url "https://api.africastalking.com/version1"
  @sandbox_url "https://api.sandbox.africastalking.com/version1"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  Collects application data from Africas Talking endpoint, Use this function to collect
  Data about your application

  ## Parameters
  * `none`

  ## Examples
      iex> AtEx.Gateway.Application.get_data()
      {:ok, %{"UserData" => %{"balance" => "ZAR -1.3448"}} }
  """

  @spec get_data :: {:ok, map()} | {:error, term()}
  def get_data do
  # changed Application.get_env to 
    username = Application.fetch_env(:at_ex, :username)

    params =
      %{}
      |> Map.put(:username, username)

    with {:ok, %{status: 200} = res} <- get("/user", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
