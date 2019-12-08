defmodule AtEx.Gateway.Voice do
  @accept "application/json"
  @key Application.get_env(:at_ex, :api_key)
  @content_type "application/x-www-form-urlencoded"
  # voice endpoints
  @live_voice_url "https://voice.africastalking.com"
  @sandbox_voice_url "https://voice.sandbox.africastalking.com"

  # Using this system for delivery of which URL to use (sandbox or live)
  # determined by whether we are in production or development or test
  # Selection of the live URL can be forced by setting an environment
  # variable FORCE_TOKEN_LIVE=YES

  defp get_voice_url() do
    cond do
      Mix.env() == :prod -> @live_voice_url
      System.get_env("FORCE_VOICE_LIVE") == "YES" -> @live_voice_url
      true -> @sandbox_voice_url
    end
  end

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
    - map: a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
     link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys

  ## Examples
      iex> AtEx.Gateway.Voice.make_a_call(%{from: "+254728833181", to: "+254728833000"})
  """

  @spec make_a_call(map()) :: {:ok, term()} | {:error, term()}
  def make_a_call(attrs) do
    call_middleware = [
      {Tesla.Middleware.BaseUrl, get_voice_url()},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {"accept", @accept},
         {"content-type", @content_type},
         {"apikey", @key}
       ]}
    ]

    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %Tesla.Env{body: body, status: 200}} <-
           Tesla.post(Tesla.client(call_middleware), "/call", params),
         {:ok, body} <- Jason.decode(body) do
      case body do
        # Only success case
        %{
          "entries" => [
            %{
              "phoneNumber" => _calling_from,
              "sessionId" => _session_id,
              "status" => "Queued"
            }
          ],
          "errorMessage" => "None"
        } ->
          {:ok, body}

        %{
          "entries" => [
            %{
              "phoneNumber" => _calling_from,
              "sessionId" => "None",
              "status" => message
            }
          ],
          "errorMessage" => "None"
        } ->
          {:error, "Failure - #{message}"}

        _ ->
          {:error, "Failure - Unknown Error"}
      end
    else
      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, "#{status} - #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
