defmodule AtEx.Gateway.Voice.MakeCall do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Voice API endpoints to make an outbound call 
  """

  import AtEx.Util

  @live_url "https://voice.africastalking.com"
  @sandbox_url "https://voice.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function makes a POST request to make a call  via the Africa's talking call endpoint, this
  function accepts a map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
  - `from` - your Africa’s Talking phone number (in international format i.e. +XXXYYYYYY)
  - `to` - A comma separated string of recipients’ phone numbers.
  - `clientRequestId` - (optional) Variable sent to your Events Callback URL that can be used to tag the call

  ## Example
      iex> AtEx.Gateway.Voice.MakeCall.call(%{
      ...>   to: "+254728907896",
      ...>   from: "+254728900922",
      ...> })
      {:ok, 
        %{
            "entries" => [
            %{
                "phoneNumber" => "+254728907896",
                "sessionId" => "ATVId_cb29c2b9fc27983827afc00786c4f9ea",
                "status" => "Queued"
            }
            ],
            "errorMessage" => "None"
        }}
  """

  @spec call(map()) :: {:ok, term()} | {:error, term()}
  def call(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/call"
    |> post(params)
    |> process_result()
  end
end
