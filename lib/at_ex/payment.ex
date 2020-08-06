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

  @spec card_checkout(map) :: {:error, any} | {:ok, any}
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

  @doc """
  Topup stash APIs allow you to move money from a Payment Product to an Africa’s Talking application stash.
  An application stash is the wallet that funds your service usage expences.

  ## Parameters
  map: - a map containing:
  - `productName` Africa’s Talking Payment product to initiate this transaction.
  - `currencyCode`  3-digit ISO format currency code for the value of this transaction (e.g KES, UGX, USD)
  - `amount`  Amount - in the provided currency - that the application will be topped up with.
  - `metadata`  A map of any metadata that you would like us to associate with the request. Use this field to send data that will map notifications to topup stash requests. It will be included in the notification we send once the topup stash request is completed.

  ## Example
      iex> AtEx.Payment.topup(%{ currencyCode: "KES", amount: 1500, productName: "AtEx", metadata: %{ message: "I am here"}})
        {:ok,
          %{
            "status" => "Success",
            "description" => "Topped up user stash. New Stash Balance: KES 1500.00",
            "transactionId" => "ATPid_SampleTxnId123"
          }
        }
  """
  defdelegate topup(map), to: Payments.TopupStash

  @doc """
  Find a particular payment transaction by sending a HTTP GET request to the following endpoint

  ## Parameters
  attrs: - a map containing:
  - `transactionId` - ID of the transaction you would like to find.
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffind_transaction

  ## Example 
        iex>AtEx.Payment.find_transaction(%{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795"})
        {:ok,
        %{
        "status" => "Success",
        "data" => %{
            "requestMetadata" => %{
                "reason" => "Testing things..."
            },
            "sourceType" => "Wallet",
            "source" => "PaymentWallet",
            "provider" => "Mpesa",
            "destinationType" => "PhoneNumber",
            "description" => "The service request is processed successfully.",
            "providerChannel" => "824879",
            "transactionFee" => "KES 1.0000",
            "providerRefId" => "SAMPLE_MPESA_CODE",
            "providerMetadata" => %{
                "recipientIsRegistered" => "true",
                "recipientName" => "254724XXXYYY - John Doe"
            },
            "status" => "Success",
            "productName" => "testing",
            "category" => "MobileB2C",
            "transactionDate" => "12.05.2018 21:46:13",
            "destination" => "+254708663158",
            "value" => "KES 2900.0000",
            "transactionId" => "ATPid_b9379b671fee8ccf24b2c74f94da0ceb",
            "creationTime" => "2018-05-12 18:46:12"
        }
        }}
  """
  defdelegate find_transaction(map), to: Payments.Query.FindTransaction

  @doc """
  Fetch transactions of a particular payment product by sending a HTTP GET request to the following endpoint

  ## Parameters
  attrs: - a map containing:
  - `productName` - The name of the payment product whose transactions you’d like to fetch.
  - `pageNumber` - The number of the page you’d like to read results from. Please Note: This STARTS from `1` and NOT `0`
  - `count` - The number of transaction results you would like for this query. Must be `> 1` and `< 1,000`
  - and optional parameters `startDate`, `endDate`, `category`, `provider`, `status`, `source`, `destination` and `providerChannel`
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffetch_product_transactions

  ## Example 
        iex>AtEx.Payment.fetch_product_transactions(%{productName: "AtEx", pageNumber: 1, count: 10})
        {:ok,
        %{
        "status" => "Success",
        "responses" => %{
            "requestMetadata" => %{
                "reason" => "Testing things..."
            },
            "sourceType" => "Wallet",
            "source" => "PaymentWallet",
            "provider" => "Mpesa",
            "destinationType" => "PhoneNumber",
            "description" => "The service request is processed successfully.",
            "providerChannel" => "824879",
            "transactionFee" => "KES 1.0000",
            "providerRefId" => "SAMPLE_MPESA_CODE",
            "providerMetadata" => %{
                "recipientIsRegistered" => "true",
                "recipientName" => "254724XXXYYY - John Doe"
            },
            "status" => "Success",
            "productName" => "testing",
            "category" => "MobileB2C",
            "transactionDate" => "12.05.2018 21:46:13",
            "destination" => "+254708663158",
            "value" => "KES 2900.0000",
            "transactionId" => "ATPid_b9379b671fee8ccf24b2c74f94da0ceb",
            "creationTime" => "2018-05-12 18:46:12"
        }
        }}
  """
  defdelegate fetch_product_transactions(map), to: Payments.Query.FetchProductTransactions

  @doc """
  Fetch your wallet transactions by sending a HTTP GET request to the following endpoint

  ## Parameters
  attrs: - a map containing:
  - `pageNumber` - The number of the page you’d like to read results from. Please Note: This STARTS from `1` and NOT `0`
  - `count` - The number of transaction results you would like for this query. Must be `> 1` and `< 1,000`
  - and optional parameters `startDate`, `endDate`, `categories`, `provider`, `status`, `source`, `destination` and `providerChannel`
  For more on how to use these keys https://build.at-labs.io/docs/payments%2Fquery%2Ffetch_wallet_transactions

  ## Example 
        iex>AtEx.Payment.fetch_wallet_transactions(%{ pageNumber: 1, count: 10})
        {:ok,
        %{
        "description" => "Success",
        "responses" => [
            %{
            "balance" => "KES 90.0000",
            "category" => "Debit",
            "date" => "2020-07-13 13:46:08",
            "description" => "MobileB2B Payment Request to Mine",
            "transactionId" => "ATPid_2504d5f5d28256fa264e815518e3ab0d",
            "value" => "KES 10.0000"
            },
            %{
            "balance" => "KES 90.0000",
            "category" => "Debit",
            "date" => "2020-07-10 18:50:22",
            "description" => "MobileB2C Payment Request to +254724540000",
            "transactionId" => "ATPid_5e635fa1099b4c7f69e63a0cbc3120c4",
            "value" => "KES 10.0000"
            },
            %{
            "balance" => "KES 90.0000",
            "category" => "Debit",
            "date" => "2020-07-01 15:18:33",
            "description" => "MobileB2C Payment Request to +254724540000",
            "transactionId" => "ATPid_beeb0be6b1bff57ec8f32675fe3f6e72",
            "value" => "KES 10.0000"
            }
        ],
        "status" => "Success"
        }}
  """
  defdelegate fetch_wallet_transactions(map), to: Payments.Query.FetchWalletTransactions

  @doc """
  Find a particular payment transaction by sending a HTTP GET request to the following endpoint

  ## Example 
        iex>AtEx.Gateway.Payments.Query.WalletBalance.balance()
        {:ok, %{"balance" => "KES 90.0000", "status" => "Success"}}
  """
  defdelegate balance(), to: Payments.Query.WalletBalance
end
