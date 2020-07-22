defmodule AtEx.Sms do
  @moduledoc false

  alias AtEx.Gateway.Sms

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
    - map: a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
      link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys

  ## Examples
  iex> AtEx.Sms.send_sms(%{to: "+254721978097", message: "Howdy"})
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
  defdelegate send_sms(map), to: Sms.Bulk

  @doc """

  This function makes a get request to fetch an SMS via the Africa's talking SMS endpoint, this
  function accepts an map of parameters that optionally accepts `lastReceivedId` of the message.
  sent

  ## Parameters
    - map: an empty map or a map containing optionally `lastReceivedId` of the message to be fetched

  ## Examples
      iex> AtEx.Sms.fetch_sms(%{})
      {:ok,
        %{"SMSMessageData" =>
          %{"Messages" =>
            []
          }
        }
      }

  """
  defdelegate fetch_sms(map), to: Sms.Bulk
end
