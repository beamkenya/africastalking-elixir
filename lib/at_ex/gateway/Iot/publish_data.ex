defmodule AtEx.Gateway.Iot.PublishData do
  import AtEx.Util

  @moduledoc """
  This module allows you to make an HTTP POST to publish messages to your remote devices.
  """
  @live_url "https://iot.africastalking.com"
  @sandbox_url "https://iot.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url), type: "json"

  @doc """
  This function makes a POST request to to publish messages to your remote devices through the
  Africa's talking IOT endpoint
  The function accepts a map of parameters.


  ## Parameters
  attrs: - a map containing:
  - `deviceGroup` - The device group to which the message is to be sent
  - `topic` - The messaging channel to which the message is to be sent. In the form <username>/<device-group>/<the-topic>
  - `payload` - The message packet to be sent to the subscribed devices.

  ## Example
      iex> AtEx.Gateway.Iot.PublishData.publish(%{
      ...>   deviceGroup: "CrazyCats",
      ...>   topic: "any-topic",
      ...>   payload: "take me to your leader"
      ...> })
      {:ok, %{ "status" => true, "description" => "Message processed successfully"}}

  """

  def publish(attrs) do
    username = Application.get_env(:at_ex, :username)
    device_group = attrs.deviceGroup
    message_topic = attrs.topic
    topic = "#{username}" <> "/" <> "#{device_group}" <> "/" <> "#{message_topic}"

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:topic, topic)

    "/data/publish"
    |> post(params)
    |> process_result()
  end
end
