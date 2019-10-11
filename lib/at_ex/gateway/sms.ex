defmodule AtEx.Gateway.Sms do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API
  SMS endpoint, use it to POST and GET requests to the SMS endpoint
  """
  use AtEx.Gateway.Base, url: "https://api.sandbox.africastalking.com/version1"

  @doc """
  This function builds and runs a post request to send an SMS via the Africa's talking SMS endpoint, this
  function accepts a map of parameters that should always contain  the `to` address and the `message` to be
  sent

  ## Parameters
  attrs: - a map containing a `to` and `message` key optionally it may also contain `from`, bulk_sms, enqueue, key_word
  link_id and retry_hours keys, see the docs at https://build.at-labs.io/docs/sms%2Fsending for how to use these keys
  """
  @spec send_sms(map()) :: {:ok, term()} | {:error, term()}
  def send_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %{status: 201} = res} <- post("/messaging", params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  This function makes a get request to fetch an SMS via the Africa's talking SMS endpoint, this
  function accepts an map of parameters that optionally accepts `lastReceivedId` of the message.
  sent

  ## Parameters
  attrs: - an empty map or a map containing optionally `lastReceivedId` of the message to be fetched, see the docs at https://build.at-labs.io/docs/sms%2Ffetch_messages for how to use these keys
  """

  @spec fetch_sms(map()) :: {:error, any()} | {:ok, any()}
  def fetch_sms(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.to_list()

    with {:ok, %{status: 200} = res} <- get("/messaging", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end

  # Checkout token endpoints
  @live_token_url "https://api.africastalking.com/checkout/token"
  @sandbox_token_url "https://api.sandbox.africastalking.com/checkout/token"

  # Using this system for delivery of which URL to use (sandbox or live) 
  # determined by whether we ar in production or development or test
  # Selection of the live URL can be forced by setting an environment
  # variable FORCE_TOKEN_LIVE=YES
  defp get_token_url do
    cond do
      Mix.env() == :prod -> @live_token_url
      System.get_env("FORCE_TOKEN_LIVE") == "YES" -> @live_token_url
      true -> @sandbox_token_url
    end
  end

  @doc """
  This function fetches the checkout token from the checkout token endpoint
  THIS IS DIFFERENT THAN THE SMS ENDPOINT!!

  phone_number: - a string representing a valid phone number in EL64 
  (+<country code><phone number> with all non digit characters removed)
  [NOTE:  function does not verify the phone number is in any way correct
   before sending to the endpoint.]

  Returns a success tuple: {:ok, <client_token>}} or {:error, <reason>}
  """

  @spec generate_checkout_token(String.t()) :: {:error, any()} | {:ok, any()}
  def generate_checkout_token(phone_number) do
    # Can't use the default client, since we have a different URL
    token_middleware = [
      {Tesla.Middleware.BaseUrl, get_token_url()},
      Tesla.Middleware.FormUrlencoded
    ]

    with {:ok, %Tesla.Env{body: body, status: 201}} <-
           Tesla.post(Tesla.client(token_middleware), "/create", %{phoneNumber: phone_number}),
         {:ok, body} <- Jason.decode(body) do
      case body do
        # Only success case
        %{"description" => "Success", "token" => token} ->
          {:ok, token}

        %{"description" => "Failure", "token" => message} ->
          {:error, "Failure - #{message}"}

        %{"description" => message, "token" => "None"} ->
          {:error, "Failure - #{message}"}

        _ ->
          {:error, "Failure - Unknown Error"}
      end
    else
      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, "#{status} - #{body}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  This function makes a post request to subscribe to premium sms content via the Africa's talking subscription endpoint, this
  function accepts an map of parameters.
  sent

  ## Parameters
  attrs: - a map containing:
  - `shortCode` - premium short code mapped to your account
  - `keyword` - premium keyword under the above short code mapped to your account
  - `phoneNumber` - phone number to be subscribed

  ## Example
      iex> AtEx.Gateway.Sms.create_subscription(%{
      ...>   shortCode: "1234",
      ...>   keyword: "keyword",
      ...>   phoneNumber: "+2541231111"
      ...> })
      {:ok, result}
  """
  @spec create_subscription(map()) :: {:error, any()} | {:ok, any()}
  def create_subscription(%{phoneNumber: phone_number} = attrs) do
    username = Application.get_env(:at_ex, :username)

    case generate_checkout_token(phone_number) do
      {:ok, token} ->
        params =
          attrs
          |> Map.put(:username, username)
          |> Map.put(:checkoutToken, token)

        with {:ok, %{status: 201} = res} <- post("/subscription/create", params) do
          {:ok, Jason.decode!(res.body)}
        else
          {:ok, val} ->
            {:error, %{status: val.status, message: val.body}}

          {:error, message} ->
            {:error, message}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

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
      iex> AtEx.Gateway.Sms.create_subscription(%{
      ...>   shortCode: "1234",
      ...>   keyword: "keyword",
      ...> })
      {:ok, result}
  """
  @spec fetch_subscriptions(map()) :: {:error, any()} | {:ok, any()}
  def fetch_subscriptions(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %{status: 200} = res} <- get("/subscription", query: params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  This function makes a POST request to delete sms subscriptions via the Africa's talking subscription endpoint, this
  function accepts an map of parameters:

  ## Parameters
  attrs: - a map containing:
  - `shortCode` - premium short code mapped to your account
  - `keyword` - premium keyword under the above short code mapped to your account
  - `phoneNumber` - phone number to be unsubscribed

  ## Example
      iex> AtEx.Gateway.Sms.delete_subscription(%{
      ...>   shortCode: "1234",
      ...>   keyword: "keyword",
      ...>   phoneNumber: "+2541231111"
      ...> })
      {:ok,  %{"description" => "Succeeded", "status" => "Success"}}
  """
  @spec delete_subscription(map()) :: {:error, any()} | {:ok, any()}
  def delete_subscription(attrs) do
    username = Application.get_env(:at_ex, :username)

    params =
      attrs
      |> Map.put(:username, username)

    with {:ok, %{status: 201} = res} <- post("/subscription/delete", params) do
      {:ok, Jason.decode!(res.body)}
    else
      {:ok, val} ->
        {:error, %{status: val.status, message: val.body}}

      {:error, message} ->
        {:error, message}
    end
  end
end
