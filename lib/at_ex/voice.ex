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
end
