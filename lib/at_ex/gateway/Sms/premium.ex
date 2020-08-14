defmodule AtEx.Gateway.Sms.PremiumSubscriptions do
  @moduledoc """
  This module holds the implementation for the HTTP Gateway that runs calls against the Africas Talking API Premium SMS endpoint, complete a premium sms create subscription request, incrementally fetch your premium sms subscriptions, delete a premium sms subscription
  """

  import AtEx.Util

  @live_url "https://api.africastalking.com/version1"
  @sandbox_url "https://api.sandbox.africastalking.com/version1"

  use AtEx.Gateway.Base, url: get_url(@live_url, @sandbox_url)

  # Checkout token endpoints
  @live_token_url "https://api.africastalking.com/checkout/token"
  @sandbox_token_url "https://api.sandbox.africastalking.com/checkout/token"

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
      {Tesla.Middleware.BaseUrl, get_url(@live_token_url, @sandbox_token_url)},
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

  ## Config
  Add `shortcode`, and `keyword` to the AtEx `configs`

  ## Parameters
  attrs: - a map containing:
  - `phoneNumber` - phone number to be subscribed
  Check https://build.at-labs.io/docs/sms%2Fpremium_subscriptions%2Fcreate

  ## Example
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.create_subscription(%{phoneNumber: "+25471231111"})
      {:ok, 
        %{
        "SMSMessageData" => %{"Message" => "Sent to 1/1 Total Cost: ZAR 0.1124", "Recipients" => [%{"cost" => "KES 0.8000", "messageId" => "ATXid_a584c3fd712a00b7bce3c4b7b552ac56", "number" => "+254728833181", "status" => "Success", "statusCode" => 101}]}
        }}
  """
  @spec create_subscription(map()) :: {:error, any()} | {:ok, any()}
  def create_subscription(%{phoneNumber: phone_number} = attrs) do
    username = Application.get_env(:at_ex, :username)
    shortcode = Application.get_env(:at_ex, :short_code)
    keyword = Application.get_env(:at_ex, :keyword)

    case generate_checkout_token(phone_number) do
      {:ok, token} ->
        params =
          attrs
          |> Map.put(:username, username)
          |> Map.put(:shortCode, shortcode)
          |> Map.put(:keyword, keyword)
          |> Map.put(:checkoutToken, token)

        "/subscription/create"
        |> post(params)
        |> process_result

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
  For more info, look at the docs here https://build.at-labs.io/docs/sms%2Fpremium_subscriptions%2Ffetch

  ## Example
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.fetch_subscriptions()
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
  @spec fetch_subscriptions() :: {:error, any()} | {:ok, any()}
  def fetch_subscriptions() do
    username = Application.get_env(:at_ex, :username)
    shortcode = Application.get_env(:at_ex, :short_code)
    keyword = Application.get_env(:at_ex, :keyword)

    params =
      %{}
      |> Map.put(:username, username)
      |> Map.put(:shortCode, shortcode)
      |> Map.put(:keyword, keyword)

    "/subscription"
    |> get(query: params)
    |> process_result
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
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.delete_subscription(%{ phoneNumber: "+25471231111"})
      {:ok,  %{"description" => "Succeeded", "status" => "Success"}}
  """
  @spec delete_subscription(map()) :: {:error, any()} | {:ok, any()}
  def delete_subscription(attrs) do
    username = Application.get_env(:at_ex, :username)
    shortcode = Application.get_env(:at_ex, :short_code)
    keyword = Application.get_env(:at_ex, :keyword)

    params =
      attrs
      |> Map.put(:username, username)
      |> Map.put(:shortCode, shortcode)
      |> Map.put(:keyword, keyword)

    "/subscription/delete"
    |> post(params)
    |> process_result
  end
end
