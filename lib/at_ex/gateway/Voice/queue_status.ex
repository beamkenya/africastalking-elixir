defmodule AtEx.Gateway.Voice.QueueStatus do
  import AtEx.Util

  @live_url "https://voice.africastalking.com"
  @sandbox_url "https://voice.sandbox.africastalking.com"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function makes a POST request to check the queue status of voice calls via the Africa's talking queue status endpoint, this
  function accepts a map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
    - `username` - Your Africa’s Talking application username. Can be set in the config
    - `phoneNumbers` - A comma separated list of one or more numbers mapped to your Africa’s Talking account.


  ## Example
        iex> AtEx.Gateway.Voice.QueueStatus.status(%{
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

  def status(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/queueStatus"
    |> post(params)
    |> process_result()
  end
end
