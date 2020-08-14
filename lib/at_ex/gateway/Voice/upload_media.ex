defmodule AtEx.Gateway.Voice.UploadMedia do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking Voice API endpoint tfor uploading media file
  """

  import AtEx.Util

  @live_url "https://voice.africastalking.com"
  @sandbox_url "https://voice.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function makes a POST request to upload a media in the Africa's talking queue status endpoint, this
  function accepts a map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
    - `username` - Your Africa’s Talking application username. Can be set in the config
    - `url` - The url of the file to upload. Don’t forget to start with http://


  ## Example
      iex> AtEx.Gateway.Voice.UploadMedia.upload(%{
               phoneNumber: "+254728833180",
        ...>   url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3"
        ...> })
        {:ok, result}
  """

  def upload(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %{status: 201} = res} <- post("/mediaUpload", params) do
      {:ok, res.body}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
