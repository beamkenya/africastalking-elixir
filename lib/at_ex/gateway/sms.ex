defmodule AtEx.Gateway.Sms do
    @moduledoc  """
    This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
    """


  @doc """
  Sends HTTP Post request to the AT API to send out SMSes

  ## Parametets
  - params: A map of parameters containing valid Sms Send inputs refer to https://build.at-labs.io/docs/sms%2Fsending
  """
  @spec send_sms() :: {:ok, map()} | {:error, term()
  def send_sms(params) do
      query = Map.to_list(params)

      client = build_client(:send_sms)

      with {:ok, %{status: 200}} <- Tesla.post(client, "/messaging", query: query), 
           {:ok, resp.body}
      else  
        {:error, val} ->
          {:error, val}

        {:ok, resp} ->
          {:error, resp.body}
      end 
    end



    def fetch_sms() do
    end

    @spec build_client(atom()) :: Tesla.Client.t()
    defp build_client(:send_sms) do
      env = Application.get_env(:at_ex, :endpoint)
      
      base_url =
        case env do
          "sandbox" ->
            "https://api.sandbox.africastalking.com/version1"

          "live" ->
            "https://api.africastalking.com/version1"
        end

      middleware = build_middleware(base_url)
      
      Tesla.client(middleware)
    end
    
    defp build_middleware(url) do
      accept = Application.get_env(:at_ex, :accept)
      content = Application.get_env(:at_ex, :content_type)
      key = Application.get_env(:at_ex, :api_key)


      middleware = [
        {Tesla.Middleware.BaseUrl, url},  
        {Tesla.Middleware.Headers, [{"content-type", content},{"apiKey", key}, {"accept", accept}]}
      ]

      middleware
    end 
end
