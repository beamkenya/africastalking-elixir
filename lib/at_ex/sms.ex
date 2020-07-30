defmodule AtEx.Sms do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API SMS endpoints
  """

  alias AtEx.Gateway.Sms

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
    - map: a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
      link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys

  ## Examples
        iex> AtEx.Sms.send_sms(%{to: "+254728833181", message: "Howdy"})
        {:ok,
        %{
            "SMSMessageData" => %{
            "Message" => "Sent to 1/1 Total Cost: ZAR 0.1124",
            "Recipients" => [
            %{
            "cost" => "KES 0.8000",
            "messageId" => "ATXid_96e52a761a82c1bad58e885109224aad",
            "number" => "+254728833181",
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

  @doc """
  This function makes a post request to subscribe to premium sms content via the Africa's talking subscription endpoint, this
  function accepts an map of parameters.
  sent

  ## Config
  Add `shortcode`, and `keyword` to the AtEx `configs`

  ## Parameters
  attrs: - a map containing:
  - `phoneNumber` - phone number to be subscribed
  Check https://build.at-labs.io/docs/sms%2Fpremium_subscriptions%2Fcreate

  ## Example
      iex> AtEx.Sms.create_subscription(%{phoneNumber: "+25471231111"})
      {:ok, 
        %{
        "SMSMessageData" => %{"Message" => "Sent to 1/1 Total Cost: ZAR 0.1124", "Recipients" => [%{"cost" => "KES 0.8000", "messageId" => "ATXid_a584c3fd712a00b7bce3c4b7b552ac56", "number" => "+254728833181", "status" => "Success", "statusCode" => 101}]}
        }}
  """
  defdelegate create_subscription(map), to: Sms.PremiumSubscriptions

  @doc """
  This function makes a GET request to fetch premium sms subscriptions via the Africa's talking subscription endpoint, this
  function accepts an map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
  - `shortCode` - premium short code mapped to your account
  - `keyword` - premium keyword under the above short code mapped to your account
  - `lastReceivedId` - (optional) ID of the subscription you believe to be your last. Set it to 0 to for the first time.

  ## Example
      iex> AtEx.Sms.fetch_subscriptions()
      {:ok, 
        %{
              "SMSMessageData" => %{
                "Messages" => [
                  %{
                    "linkId" => "SampleLinkId123",
                    "text" => "Hello",
                    "to" => "28901",
                    "id" => 15071,
                    "date" => "2018-03-19T08:34:18.445Z",
                    "from" => "+254711XXXYYY"
                  }
                ]
              }
            }}
  """
  defdelegate fetch_subscriptions(), to: Sms.PremiumSubscriptions

  @doc """
  This function makes a POST request to delete sms subscriptions via the Africa's talking subscription endpoint, this
  function accepts an map of parameters:

  ## Parameters
  attrs: - a map containing:
  - `shortCode` - premium short code mapped to your account
  - `keyword` - premium keyword under the above short code mapped to your account
  - `phoneNumber` - phone number to be unsubscribed

  ## Example
      iex> AtEx.Sms.delete_subscription(%{ phoneNumber: "+25471231111"})
      {:ok,  %{"description" => "Succeeded", "status" => "Success"}}
  """
  defdelegate delete_subscription(map), to: Sms.PremiumSubscriptions
end
