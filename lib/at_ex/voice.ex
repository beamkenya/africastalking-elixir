defmodule AtEx.Voice do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API Voice endpoints
  """
  alias AtEx.Gateway.Voice

  @doc """
  This function makes a POST request to make a call  via the Africa's talking call endpoint, through delegation
  this function accepts a map of parameters.
  sent

  ## Config
  Add `b2b_product_name` key to the AtEx config values

  ## Parameters
  attrs: - a map containing:
  - `from` - your Africa’s Talking phone number (in international format i.e. +XXXYYYYYY)
  - `to` - A comma separated string of recipients’ phone numbers.
  - `clientRequestId` - (optional) Variable sent to your Events Callback URL that can be used to tag the call

  ## Example
      iex> AtEx.Voice.call(%{
      ...>   to: "+254728907896",
    ...>   from: "+254728900922",
      ...> })
      {:ok, result}
  """
  defdelegate call(map), to: Voice.MakeCall

  @doc """
  This function makes a POST request to check the queue status of voice calls via the Africa's talking queue status endpoint, this
  function accepts a map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
    - `username` - Your Africa’s Talking application username. Can be set in the config
    - `phoneNumbers` - A comma separated list of one or more numbers mapped to your Africa’s Talking account.


  ## Example
        iex> AtEx.Voice.status(%{
        ...>   phoneNumbers: "+254728833180, +254728907896"
        ...> })
        {:ok,
        %{
              "entries" => [
                %{
                  "phoneNumber" => "+254728833180",
                  "queueName" => "",
                  "numCalls" => 1
                },
                %{
                  "phoneNumber" => "+254728907896",
                  "queueName" => "",
                  "numCalls" => 4
                }
              ],
              "errorMessage" => "None",
              "status" => "Success"
            }}
  """
  defdelegate status(map), to: Voice.QueueStatus

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
      iex> AtEx.Voice.transfer(%{
      ...>   sessionId: "ATVId_47ef478e918923e7b2d0921ebd5b66a6",
      ...>   phoneNumber: "+254728900922",
      ...> })
      {:ok, result}
  """
  defdelegate transfer(map), to: Voice.CallTransfer
end
