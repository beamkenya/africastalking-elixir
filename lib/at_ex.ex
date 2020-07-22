defmodule AtEx do
  @moduledoc """
  AtEx is an Elixir Wrapper for the Africas Talking Api

  Use this library to handle interaction with the Africas Talking API end points,
  It is most useful for
  - Consuming incoming events that have been parsed
  - Building valid responses

  This is in development, currently the following parts of the API are working:
  - SMS (Non Premium Sms)
  - USSD
  - Airtime
  - Application

  ## Getting Started
  Configuration
    config :at_ex,
      api_key: "YOURAPIKEY",
      content_type: "application/x-www-form-urlencoded",
      accept: "application/json",
      username: "YOURUSERNAME"
  """
  alias AtEx.Gateway.{
    Airtime,
    Application,
    Sms,
    Payments,
    Voice
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
  defdelegate send_sms(map), to: Sms.Bulk

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

  defdelegate fetch_sms(map), to: Sms.Bulk

  @doc """
  This function initiates a mobile checkout request by sending a HTTP POST request to the Africa's talking Mobile Checkout endpoint.

  ## Parameters
  attrs: - a map containing a `phoneNumber`, `currencyCode` and `amount` key optionally it may also contain `providerChannel` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fcheckout for how to use these keys

  ## Example 
    iex>AtEx.mobile_checkout(%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES"})
    %{
    "description" => "Waiting for user input",
    "providerChannel" => "525900",
    "status" => "PendingConfirmation",
    "transactionId" => "ATPid_bbd0bcd713e27d9201807076c6db0ed5"
    }
  """
  defdelegate mobile_checkout(map), to: Payments.Mobile.Checkout

  @doc """
  This function initiates a mobile B2C request by making a HTTP POST request to the Africa's talking Mobile B2C endpoint.

  ## Config
  Add `stk_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a list of Recipient each a map containing a `phoneNumber`, `currencyCode`, `amount` and a map of `metadata` key optionally it may also contain `name`, `reason` and `providerChannel` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fb2c%2Foverview for how to use these keys

  ## Example 
    iex>AtEx.b2c_checkout([%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES", metadata: %{ message: "I am here"}}])
    {:ok,
  %{
   "entries" => [
     %{
       "phoneNumber" => "+254724540000",
       "provider" => "Athena",
       "providerChannel" => "525900",
       "status" => "Queued",
       "transactionFee" => "KES 0.1000",
       "transactionId" => "ATPid_2b76da39eebd5c6bcc49e5d30c3d0390",
       "value" => "KES 10.0000"
     }
   ],
   "numQueued" => 1,
   "totalTransactionFee" => "KES 0.1000",
   "totalValue" => "KES 10.0000"
  }}
  """
  defdelegate b2c_checkout(map), to: Payments.Mobile.B2c

  @doc """
  Mobile Business To Business (B2B) APIs allow you to send payments to businesses e.g banks from your Payment Wallet.

  ## Config
  Add `b2c_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a map containing a `provider(Mpesa,TigoTanzania,Athena)`, `transferType(BusinessBuyGoods,BusinessPayBill, DisburseFundsToBusiness, BusinessToBusinessTransfer)`, `currencyCode` `amount`, `destinationChannel`, `destinationAccount` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fb2b for how to use these keys

  ## Example 
    iex>AtEx.Gateway.Payments.Mobile.B2b.b2b_checkout(%{provider: "Athena", transferType: "DisburseFundsToBusiness", amount: 10, currencyCode: "KES", destinationChannel: "Mine", destinationAccount: "Mine", metadata: %{ message: "I am here"}})
    {:ok,
  %{
   "providerChannel" => "525900",
   "status" => "Queued",
   "transactionFee" => "KES 0.1000",
   "transactionId" => "ATPid_2504d5f5d28256fa264e815518e3ab0d"
  }}
  """
  defdelegate b2b_checkout(map), to: Payments.Mobile.B2b

  @doc """
  Bank checkout APIs allow your application to collect money into your payment wallet by initiating transactions that deduct money from a customers bank account.

  ## Config
  Add `bank_checkout_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a map containing `bankAccount`(a map), `currencyCode`, `amount`, `narration` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Fcheckout for how to use these keys

  ## Example 
    iex>AtEx.bank_checkout(%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}})
    {:ok,
  %{
   "description" => "Payment is pending validation by the user",
   "status" => "PendingValidation",
   "transactionId" => "ATPid_722a5dbaf1e8be4832614b523810dc29"
  }}
  """
  defdelegate bank_checkout(map), to: Payments.Bank.Checkout

  @doc """
  Bank checkout validation APIs allow your application to validate bank checkout charge requests.

  ## Parameters
  attrs: - a map containing `transactionId` and `otp` see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Fvalidate for how to use these keys

  ## Example 
    iex>AtEx.bank_validate(%{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795", otp: "password"})
    {:ok,
  %{
    "status": "Success",
    "description": "Payment completed successfully"
  }}
  """
  defdelegate bank_validate(map), to: Payments.Bank.Validate

  @doc """
  Bank checkout validation APIs allow your application to validate bank checkout charge requests.

  ## Config
  Add `bank_transfer_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a list of recipients each containing a map with `currencyCode`, `amount`, `narration` and a map of `metadata` (optional) see the docs at https://build.at-labs.io/docs/payments%2Fbank%2Ftransfer for how to use these keys

  ## Example 
    iex>AtEx.bank_transfer([%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}}])
    
    {:ok,
  %{
     "entries": [%{
        "accountNumber": "93892892",
        "status": "Queued",
        "transactionId": "ATPid_SampleTxnId",
        "transactionFee": "NGN 50.00"
    }]
  }}
  """
  defdelegate bank_transfer(map), to: Payments.Bank.Transfer

  @doc """
  This function makes a POST request to make a call  via the Africa's talking call endpoint, through delegation
  this function accepts a map of parameters.
  sent

  ## Config
  Add `b2b_product_name` key to the AtEx config values

  ## Parameters
  attrs: - a map containing:
  - `from` - your Africa’s Talking phone number (in international format i.e. +XXXYYYYYY)
  - `to` - A comma separated string of recipients’ phone numbers.
  - `clientRequestId` - (optional) Variable sent to your Events Callback URL that can be used to tag the call

  ## Example
      iex> AtEx.call(%{
      ...>   to: "+254728907896",
      ...>   from: "+254728900922",
      ...> })
      {:ok, result}
  """
  defdelegate call(map), to: Voice.MakeCall
end
