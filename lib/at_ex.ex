defmodule AtEx do
  @moduledoc """
  AtEx is an Elixir Wrapper for the Africas Talking Api
  """
  alias AtEx.Gateway.{
    Airtime,
    Application
  }

  @doc """
    Sends airtime

    ## Parameters

      - map: a map that represents the details of the party you are sending airtime to

    ## Examples

      iex> AtEx.send_airtime(%{recipients: [%{phone_number: "+254721978097", amount: "KES 50"}]})
        {:ok,
          %{
            "errorMessage" => "None",
            "numSent" => 1,
            "responses" => [
              %{
                "amount" => "KES 50.0000",
                "discount" => "KES 2.0000",
                "errorMessage" => "None",
                "phoneNumber" => "+254721978097",
                "requestId" => "ATQid_630557e624c70f2b0d2c5e90ebc282bb",
                "status" => "Sent"
              }
            ],
            "totalAmount" => "ZAR 7.0277",
            "totalDiscount" => "ZAR 0.2811"
        }}
  """
  defdelegate send_airtime(map), to: Airtime

  @doc """
  Collects application data from Africas Talking endpoint, Use this function to collect
  Data about your application

  ## Parameters
    * `none`

  ## Examples
      iex> AtEx.get_application_data()
      {:ok, %{"UserData" => %{"balance" => "ZAR -1.4572"}}}
  """
  defdelegate get_application_data(), to: Application, as: :get_data
end
