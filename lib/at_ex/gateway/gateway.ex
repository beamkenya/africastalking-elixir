defmodule AtEx.Gateway do
    @moduledoc  """
    This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
    """
    use Tesla


    @doc """
    Sends HTTP Post request to the AT API to send out SMSes

    ## Parametets
    - params: a map of parameters to use when sending the message
    """
    def send_sms(params) do
        env = Application.get_env(:at_ex, :endpoint)
        accept = Application.get_env(:at_ex, :accept)
        content = Application.get_env(:at_ex, :content_type)
        key = Application.get_env(:at_ex, :api_key)

        base_url =
            case env do
                "sandbox" ->
                    "https://api.sandbox.africastalking.com/version1/messaging"

                "live" ->
                    "https://api.africastalking.com/version1/messaging"
            end

        middleware = [
            {Tesla.Middleware.Headers, [{"content-type", content}, {"apiKey", key}, {"accept", accept}]}
        ]

        json_map =  Jason.encode!(params)

        Tesla.post(base_url, json_map, middleware)
    end



    def fetch_sms() do
    end
    
    defp build_client(:get, call) do 
        
    end 
end
