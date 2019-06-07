defmodule AtEx do
  @moduledoc """
  AtEx is an Elixir Wrapper for the Africas Talking Api

  Use this library to handle interaction with the Africas Talking API end points,
  It is most useful for
  - Consuming incoming events that have been parsed
  - Building valid responses
  """
  alias AtEx.Gateway.{
    Airtime,
    Application,
    Sms
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

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
    - map: a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
     link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys

  ## Examples
      iex> AtEx.send_sms(%{to: "+254721978097", message: "Howdy"})
      {:ok,
        %{
          "SMSMessageData" => %{
          "Message" => "Sent to 1/1 Total Cost: ZAR 0.1124",
          "Recipients" => [
          %{
           "cost" => "KES 0.8000",
           "messageId" => "ATXid_96e52a761a82c1bad58e885109224aad",
           "number" => "+254721978097",
           "status" => "Success",
           "statusCode" => 101
          }
          ]
        }
      }}
  """
  defdelegate send_sms(map), to: Sms

  @doc """

  This function makes a get request to fetch an SMS via the Africa's talking SMS endpoint, this
  function accepts an map of parameters that optionally accepts `lastReceivedId` of the message.
  sent

  ## Parameters
    - map: an empty map or a map containing optionally `lastReceivedId` of the message to be fetched

  ## Examples
      iex> AtEx.fetch_sms(%{})
       {:ok,
         %{"SMSMessageData" =>
          %{"Messages" =>
           []
          }
         }
       }

  """

  defdelegate fetch_sms(map), to: Sms
end
