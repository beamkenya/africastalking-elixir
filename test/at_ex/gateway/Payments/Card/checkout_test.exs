defmodule AtEx.Gateway.Payments.Card.CheckoutTest do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest AtEx.Gateway.Payments.Card.Checkout

  alias AtEx.Gateway.Payments.Card.Checkout

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body: %{
            status: "PendingValidation",
            description: "Waiting for user input",
            transactionId: "ATPid_SampleTxnId123"
          }
        }
    end)

    :ok
  end

  describe "Card Checkout" do
    test "card_checkout/1 should initiate card checkout  successfully" do
      details = %{
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        paymentCard: %{
          number: "10928873477387",
          cvvNumber: 253,
          expiryMonth: 12,
          expiryYear: 2020,
          countryCode: "NG",
          authToken: "jhdguyt6372gsu6q"
        }
      }

      {:ok, result} = Checkout.card_checkout(details)
      assert "PendingValidation" = result.status
    end

    test "card_checkout/1 should fail without required params 'amount'" do
      details = %{
        currencyCode: "KES",
        narration: "Payment",
        paymentCard: %{
          number: "10928873477387",
          cvvNumber: 253,
          expiryMonth: 12,
          expiryYear: 2020,
          countryCode: "NG",
          authToken: "jhdguyt6372gsu6q"
        }
      }

      {:error, message} = Checkout.card_checkout(details)

      assert "The request is missing required member 'amount'" = message
    end

    test "card_checkout/1 should fail without required params 'currencyCode'" do
      details = %{
        amount: 1000.00,
        narration: "Payment",
        paymentCard: %{
          number: "10928873477387",
          cvvNumber: 253,
          expiryMonth: 12,
          expiryYear: 2020,
          countryCode: "NG",
          authToken: "jhdguyt6372gsu6q"
        }
      }

      {:error, message} = Checkout.card_checkout(details)
      assert "The request is missing required member 'currencyCode'" = message
    end

    test "card_checkout/1 should fail without required params 'narration'" do
      details = %{
        amount: 1000.00,
        currencyCode: "KES",
        paymentCard: %{
          number: "10928873477387",
          cvvNumber: 253,
          expiryMonth: 12,
          expiryYear: 2020,
          countryCode: "NG",
          authToken: "jhdguyt6372gsu6q"
        }
      }

      {:error, message} = Checkout.card_checkout(details)

      assert "The request is missing required member 'narration'" = message
    end

    test "card_checkout/1 should fail without optional param 'metadata' is not a map" do
      details = %{
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        paymentCard: %{
          number: "10928873477387",
          cvvNumber: 253,
          expiryMonth: 12,
          expiryYear: 2020,
          countryCode: "NG",
          authToken: "jhdguyt6372gsu6q"
        },
        metadata: "a string"
      }

      {:error, message} = Checkout.card_checkout(details)
      assert "The optional member 'metadata' must be a map" = message
    end

    test "card_checkout/1 should fail without 'paymentCard' being map" do
      details = %{
        amount: 1000.00,
        currencyCode: "KES",
        narration: "Payment",
        paymentCard: "a string"
      }

      {:error, message} = Checkout.card_checkout(details)
      assert "The optional member 'paymentCard' must be a map" = message
    end
  end
end
