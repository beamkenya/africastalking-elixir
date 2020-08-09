[badges][badges] [badges]

# AtEx

> An API Wrapper for the Africas Talking API https://africastalking.com/

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [Licence](#licence)

## Features

We hope to cover all the endpoints of [Africas Talking ](https://build.at-labs.io/discover) to help elixir developers integrate its services in their applications.
Here are the main modules we hope to develop in the process.

- [x] SMS
- [x] Voice
- [x] USSD
- [x] Airtime
- [x] Payments
- [x] IoT
- [x] Application

## Installation

Available in Hex, the package can be installed by adding `at_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:at_ex, "~> 0.20.20"}
  ]
end
```

## Configuration

- Create a `dev.exs` file under the `config` folder in the root of the project if you do not have it. like `touch config/dev.exs` to setup configs for development environment i.e, sandbox credentials check sample configuration below.
- Create a `prod.exs` file under the `config` folder in the root of the project if you dont have it. like `touch config/prod.exs` to setup `at_ex` configs for production environment i.e, live credentials check sample configuration below.
- Copy the contents of `dev.sample.exs` into the `dev.exs` created above.
- Go to [Africas Talking](https://account.africastalking.com/auth/register) to register for an account.
- On signing up go to the `https://account.africastalking.com/apps/sandbox` to get an **api key**
- Add the **api key** in the `api_key:`value in the `config/dev.exs` created above.

## Example Configuration setup
``` elixir
config :at_ex,
  api_key: "===INSERT AFRICAS_TALKING_API_KEY HERE ===",
  content_type: "application/x-www-form-urlencoded",
  accept: "application/json",
  username: "sandbox", #change to live username for prod.ex
  stk_product_name: "AtEx", #Add your specific product name.
  b2c_product_name: "AtEx",
  b2b_product_name: "AtEx",
  bank_checkout_product_name: "AtEx",
  bank_transfer_product_name: "AtEx",
  card_checkout_product_name: "AtEx",
  # When changed to "YES" one will use the live endpoint url when in development
  force_live_url: "NO"
```


## Documentation

The docs can be found at [https://hexdocs.pm/at_ex](https://hexdocs.pm/at_ex).

### Quick examples

#### Sending SMS

```elixir
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
```

#### Payment Mobile checkout

```elixir
    iex>AtEx.Payment.mobile_checkout(%{phoneNumber: "254724540000", amount: 10, currencyCode: "KES"})
    %{
        "description" => "Waiting for user input",
        "providerChannel" => "525900",
        "status" => "PendingConfirmation",
        "transactionId" => "ATPid_bbd0bcd713e27d9201807076c6db0ed5"
    }
```

## Contribution

If you'd like to contribute, start by searching through the [issues](https://github.com/beamkenya/africastalking-elixir/issues) and [pull requests](https://github.com/beamkenya/africastalking-elixir/pulls) to see whether someone else has raised a similar idea or question.
If you don't see your idea listed, [Open an issue](https://github.com/beamkenya/africastalking-elixir/issues).

Check the [Contribution guide](contributing.md) on how to contribute.

## Maintainers
The current maintainers of the project are:
1. [Tracey Onim](https://github.com/TraceyOnim)
2. [Manuel Magak](https://github.com/manuelgeek)
3. [Paul Oguda](https://github.com/kamalogudah)
4. [Sigu Magwa](https://github.com/sigu)

## Past Maintainers
1. [Zacck Osiemo](https://github.com/zacck) Thanks for kicking off the project :wink:.


## Licence

AtEx is released under [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt)

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=for-the-badge)](#)
