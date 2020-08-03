defmodule AtEx.Payment do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API Payment endpoints
  """

  alias AtEx.Gateway.Payments

  @doc """
  This function initiates a mobile checkout request by sending a HTTP POST request to the Africa's talking Mobile Checkout endpoint.

  ## Parameters
  attrs: - a map containing a `phoneNumber`, `currencyCode` and `amount` key optionally it may also contain `providerChannel` and a map of `metadata` see the docs at https://build.at-labs.io/docs/payments%2Fmobile%2Fcheckout for how to use these keys

  ## Example 

        iex>AtEx.Payment.mobile_checkout(%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES"})
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

        iex>AtEx.Payment.b2c_checkout([%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES", metadata: %{ message: "I am here"}}])
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

        iex>AtEx.Payment.b2b_checkout(%{provider: "Athena", transferType: "DisburseFundsToBusiness", amount: 10, currencyCode: "KES", destinationChannel: "Mine", destinationAccount: "Mine", metadata: %{ message: "I am here"}})
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

        iex>AtEx.Payment.bank_checkout(%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}})
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

        iex>AtEx.Payment.bank_validate(%{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795", otp: "password"})
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

        iex>AtEx.Payment.bank_transfer([%{bankAccount: %{accountName: "KCB", accountNumber: "93892892", bankCode: 234001}, amount: 1000.00, currencyCode: "KES", narration: "Payment", metadata: %{detail: "A Bill"}}])
        
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
  Card Checkout APIs allow your application to collect money into your Payment Wallet by initiating transactions that deduct money from a customers Debit or Credit Card.

  ## Config
  Add `card_checkout_product_name` key to your AtEx `configs`

  ## Parameters
  attrs: - a map containing either `paymentCard`(a map) or `checkoutToken`, `currencyCode`, `amount`, `narration` and a map of `metadata`(optional) see the docs at https://build.at-labs.io/docs/payments%2Fcard%2Fcheckout for how to use these keys

  ## Example 

        iex>AtEx.Payment.card_checkout(%{amount: 1000.00, currencyCode: "KES", narration: "Payment", paymentCard: %{number: "10928873477387", cvvNumber: 253, expiryMonth: 12, expiryYear: 2020, countryCode: "NG", authToken: "jhdguyt6372gsu6q"}})
        {:ok, %{
              status: "PendingValidation",
              description: "Waiting for user input",
              transactionId: "ATPid_SampleTxnId123"
            }}
  """
  defdelegate card_checkout(map), to: Payments.Card.Checkout

  @doc """
  Card checkout validation APIs allow your application to validate card checkout charge requests.

  ## Parameters
  attrs: - a map containing `transactionId` and `otp` see the docs at https://build.at-labs.io/docs/payments%2Fcard%2Fvalidate for how to use these keys

  ## Example 
        iex>AtEx.Payment.card_validate(%{transactionId: "ATPid_SampleTxnId123", otp: "password"})
        
        {:ok,
        %{
            "status": "Success",
            "description": "Payment completed successfully",
            "checkoutToken": "ATCdTkn_SampleCdTknId123"
        }}
  """
  defdelegate card_validate(map), to: Payments.Card.Validate
end
