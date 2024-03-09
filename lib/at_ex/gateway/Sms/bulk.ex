defmodule AtEx.Gateway.Sms.Bulk do
  import AtEx.Util

  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  SMS endpoint, use it to POST and GET requests to the SMS endpoint
  """
  @live_url "https://api.africastalking.com/version1/messaging"
  @sandbox_url "https://api.sandbox.africastalking.com/version1/messaging"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
  attrs: - a map containing a `to` and `message` key optionally it may also contain `from`, `bulkSMSMode`, `enqueue`, `keyword`, `linkId` and `retryDurationInHours` keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys

  ## Examples
        iex> AtEx.Sms.send_sms(%{to: "+254721978097", message: "Howdy"})
        {:ok,
        %{
            "SMSMessageData" => %{
            "Message" => "Sent to 1/1 Total Cost: ZAR 0.1124",
            "Recipients" => [
                %{
                "cost" => "KES 0.8000",
                "messageId" => "ATXid_a584c3fd712a00b7bce3c4b7b552ac56",
                "number" => "+254721978097",
                "status" => "Success",
                "statusCode" => 101
                }
            ]
        }
        }}
  """
  @spec send_sms(map()) :: {:ok, term()} | {:error, term()}
  def send_sms(%{to: _to, message: _msg} = attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    "/messaging"
    |> post(params)
    |> process_result()
  end

  def send_sms(%{to: _to}) do
    {:error, %{status: 400, message: "Request is missing required form field 'message'"}}
  end

  def send_sms(%{message: _msg}) do
    {:error, %{status: 400, message: "Request is missing required form field 'to'"}}
  end

  def send_sms(_) do
    {:error,
     %{status: 400, message: "Request is missing required form fields 'to' and 'message'"}}
  end

  @doc """
  This function makes a get request to fetch an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that optionally accepts `lastReceivedId` of the message.
  sent

  ## Parameters
  attrs: - an empty map or a map containing optionally `lastReceivedId` of the message to be fetched, see the docs at https://build.at-labs.io/docs/sms%2Ffetch_messages for how to use these keys

  ## Examples
      iex> AtEx.Sms.fetch_sms(%{})
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
        }
      }

  """

  @spec fetch_sms(map()) :: {:error, any()} | {:ok, any()}
  def fetch_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.to_list()

    "/messaging"
    |> get(query: params)
    |> process_result
  end
end
