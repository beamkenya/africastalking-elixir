defmodule AtEx.Gateway.Sms.PremiumSubscriptions do
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

  ## Parameters
  attrs: - a map containing:
  - `shortCode` - premium short code mapped to your account
  - `keyword` - premium keyword under the above short code mapped to your account
  - `phoneNumber` - phone number to be subscribed

  ## Example
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.create_subscription(%{phoneNumber: "+2541231111"})
      {:ok, result}
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
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.fetch_subscription()
      {:ok, result}
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
      iex> AtEx.Gateway.Sms.PremiumSubscriptions.delete_subscription(%{ phoneNumber: "+2541231111"})
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
