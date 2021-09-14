# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :at_ex,
  api_key: "===INSERT AFRICAS_TALKING_API_KEY HERE ===",
  # When changed to "false" one will use the live endpoint url
  sandbox: true,
  username: "sandbox",
  stk_product_name: "AtEx",
  b2c_product_name: "AtEx",
  b2b_product_name: "AtEx",
  bank_checkout_product_name: "AtEx",
  bank_transfer_product_name: "AtEx",
  card_checkout_product_name: "AtEx"

# Configure tesla to use the Hackney Adapter for
# your application and the at_ex module
config :tesla, adapter: Tesla.Adapter.Hackney
