defmodule AtEx.Gateway.Base do
  @moduledoc """
  Base HTTP Gateway for `AtEx.Gateway.Base`
  """

  @doc """
  Macro to import necessary code into HTTP Gateways, This Macro accepts a list as configuration at the moment it's used
  configure the  HTTP Base Url.

  ## Parameters
  * list: list of parameters for HTTP client configuration

  ## Examples

      defmodule AtEx.Gateway.Voice do
        use AtEx.Gateway.Base, url: "http://test.com"
        @username "some_username"

        def collect_minutes(attrs) do
          params =
          attrs
          |> Map.put(:username, @username)

          {:ok, resp} = get("/minutes", params)
          process_result(resp.body)
        end
      end
  """
  defmacro __using__(opts) do
    quote do
      use Tesla

      @config unquote(opts)

      @accept Application.get_env(:at_ex, :accept)
      @key Application.get_env(:at_ex, :api_key)
      @content_type Application.get_env(:at_ex, :content_type)

      plug(Tesla.Middleware.BaseUrl, @config[:url])
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
