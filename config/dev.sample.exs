# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :at_ex,
  api_key: "===INSERT AFRICAS_TALKING_API_KEY HERE ===",
  content_type: "application/x-www-form-urlencoded",
  accept: "application/json",
  auth_token: "",
  username: "sandbox",
  endpoint: "sandbox",
  # When changed to "YES" one will use the live endpoint url
  force_live_url: "NO"
