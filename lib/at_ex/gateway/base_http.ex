defmodule AtEx.Gateway.Base do
  @moduledoc """
  Base HTTP Gateway for `AtEx.Gateway.Base`
  """

  @doc """
  Macro to import necessary code into HTTP Gateways
  """
  defmacro __using__(configs) do
    quote do
      use Tesla

      @accept Application.get_env(:at_ex, :accept)
      @key Application.get_env(:at_ex, :api_key)
      @content_type Application.get_env(:at_ex, :content_type)

      plug(Tesla.Middleware.BaseUrl, "https://api.sandbox.africastalking.com/version1/airtime")
      plug(Tesla.Middleware.FormUrlencoded)

      plug(Tesla.Middleware.Headers, [
        {"accept", @accept},
        {"content-type", @content_type},
        {"apikey", @key}
      ])

      @doc """
      Process results from calling the gateway
      """
      def process_result(result) do
        with {:ok, res} <- Jason.decode(result) do
          {:ok, res}
        else
          {:error, val} ->
            {:error, val}
        end
      end
    end
  end
end
