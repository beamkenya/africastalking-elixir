use Mix.Config

config :tesla, adapter: Tesla.Mock

config :at_ex,
  api_key: "7c8000c4551778e357d95588bda259a0122d6f9b457c09e951984c393ccfd9f8",
  content_type: "application/x-www-form-urlencoded",
  accept: "application/json",
  auth_token: "",
  stk_product_name: "AtEx",
  b2c_product_name: "AtEx",
  b2b_product_name: "AtEx",
  bank_checkout_product_name: "AtEx",
  bank_transfer_product_name: "AtEx",
  force_live_url: "No"
