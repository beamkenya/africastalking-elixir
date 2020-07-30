defmodule AtEx.Gateway.Voice.CallTransfer do
  @moduledoc """
  This module has the call transfer functionality of AfricasTalking it allows you to
  transfer your call to another number by making a HTTP POST request to the Africas Talking voice endpoints.
  """
  import AtEx.Util

  @live_url "https://voice.africastalking.com"
  @sandbox_url "https://voice.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function makes a POST request to transfer a call to another number in the Africa's talking call endpoint, this
  function accepts a map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
  - `sessionId` - Session Id of the ongoing call, it must have two legs
  - `phoneNumber` - Phone Number to transfer the call to.
  - `callLeg` - (optional) Call leg to transfer the call to either caller or callee(Defaults to callee)
  - `holdMusicUrl` - (optional) The url of the media file to be played when the user is on hold. Don’t forget to start with http://

  ## Example
      iex> AtEx.Gateway.Voice.CallTransfer.transfer(%{
      ...>   sessionId: "ATVId_47ef478e918923e7b2d0921ebd5b66a6",
      ...>   phoneNumber: "+254728900922",
      ...> })
      {:ok, %{"callTransferResponse" => %{"errorMessage" => "None", "status" => "Success"}}}

  """

  @spec transfer(map()) :: {:ok, term()} | {:error, term()}
  def transfer(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/callTransfer"
    |> post(params)
    |> process_result()
  end
end
