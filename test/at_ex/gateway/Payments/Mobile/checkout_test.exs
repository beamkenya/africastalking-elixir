defmodule AtEx.Gateway.Payments.Mobile.CheckoutTest do
  @moduledoc false

  use ExUnit.Case
  doctest AtEx.Gateway.Payments.Mobile.Checkout
  alias AtEx.Gateway.Payments.Mobile.Checkout

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "description" => "Waiting for user input",
              "providerChannel" => "525900",
              "status" => "PendingConfirmation",
              "transactionId" => "ATPid_ca3ba091736bd8502afd4376a7519cf8"
            })
        }
    end)

    :ok
  end

  describe "Mobile Checkout" do
    test "mobile_checkout/1 should initiate mobile checkout  successfully" do
      details = %{
        phoneNumber: "254724540000",
        amount: 10,
        currencyCode: "KES",
        providerChannel: "525900"
      }

      {:ok, result} = Checkout.mobile_checkout(details)
      assert "Waiting for user input" = result["description"]
    end

    test "mobile_checkout/1 should fail without required params 'phoneNumber'" do
      details = %{
        amount: "254724540000",
        currencyCode: "KES",
        providerChannel: "525900"
      }

      {:error, message} = Checkout.mobile_checkout(details)
      assert "The request is missing required member 'phoneNumber'" = message
    end

    test "mobile_checkout/1 should fail without required params 'amount'" do
      details = %{
        phoneNumber: 10,
        currencyCode: "KES",
        providerChannel: "525900"
      }

      {:error, message} = Checkout.mobile_checkout(details)
      assert "The request is missing required member 'amount'" = message
    end

    test "mobile_checkout/1 should fail without required params 'currencyCode'" do
      details = %{
        phoneNumber: "254724540000",
        amount: 10
      }

      {:error, message} = Checkout.mobile_checkout(details)
      assert "The request is missing required member 'currencyCode'" = message
    end

    test "mobile_checkout/1 should fail without optional param 'metadata' is not a map" do
      details = %{
        phoneNumber: "254724540000",
        amount: 10,
        currencyCode: "KES",
        metadata: "a string"
      }

      {:error, message} = Checkout.mobile_checkout(details)
      assert "The optional member 'metadata' must be a map" = message
    end

    test "mobile_checkout/1 should fail without optional param 'providerChannel' is not a string" do
      details = %{
        phoneNumber: "254724540000",
        amount: 10,
        currencyCode: "KES",
        providerChannel: 12345
      }

      {:error, message} = Checkout.mobile_checkout(details)
      assert "The optional member 'providerChannel' must be a string" = message
    end
  end
end
