defmodule AtEX.Application.ApplicationData do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  SMS endpoint, use it to POST and GET requests to the SMS endpoint
  """
  use Tesla

  @accept Application.get_env(:at_ex, :accept)
  @key Application.get_env(:at_ex, :api_key)
  @content_type Application.get_env(:at_ex, :content_type)

  plug(Tesla.Middleware.BaseUrl, "https://api.sandbox.africastalking.com/version1")
  plug(Tesla.Middleware.FormUrlencoded)
  plug(Tesla.Middleware.Headers, [{"accept", @accept}, {"apikey", @key}, {"apikey", @key}])

  @doc """

  """

  def get_application_data(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, res} <- get("/user", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
