defmodule AtEx.IoT do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API IoT endpoints
  """

  alias AtEx.Gateway.Iot

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
      iex> AtEx.IoT.publish(%{
      ...>   deviceGroup: "CrazyCats",
      ...>   topic: "any-topic",
      ...>   payload: "take me to your leader"
      ...> })
      {:ok, %{ "status" => true, "description" => "Message processed successfully"}}

  """
  defdelegate publish(map), to: Iot.PublishData
end
