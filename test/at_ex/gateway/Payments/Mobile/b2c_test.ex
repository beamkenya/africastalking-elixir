defmodule AtEx.Gateway.Payments.Mobile.B2cTest do
  @moduledoc false

  use ExUnit.Case
  alias AtEx.Gateway.Payments.Mobile.B2c

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              "entries" => [
                %{
                  "phoneNumber" => "+254724540000",
                  "provider" => "Athena",
                  "providerChannel" => "525900",
                  "status" => "Queued",
                  "transactionFee" => "KES 0.1000",
                  "transactionId" => "ATPid_beeb0be6b1bff57ec8f32675fe3f6e72",
                  "value" => "KES 10.0000"
                }
              ],
              "numQueued" => 1,
              "totalTransactionFee" => "KES 0.1000",
              "totalValue" => "KES 10.0000"
            })
        }
    end)

    :ok
  end

  describe "B2c Checkout" do
    test "b2c_checkout/1 should initiate b2c checkout  successfully" do
      details = [
        %{
          phoneNumber: "254724540000",
          amount: 10,
          currencyCode: "KES",
          providerChannel: "525900",
          metadata: %{message: "I am here"}
        }
      ]

      {:ok, result} = B2c.b2c_checkout(details)
      assert 1 = result["numQueued"]
      assert is_list(result["entries"])
    end

    test "b2c_checkout/1 should fail without required params 'phoneNumber' in the recipient list item map" do
      details = [
        %{
          amount: "254724540000",
          currencyCode: "KES",
          providerChannel: "525900",
          metadata: %{message: "I am here"}
        }
      ]

      {:error, message} = B2c.b2c_checkout(details)

      assert "The request is missing required member 'phoneNumber' in one of te recipients" =
               message
    end

    test "b2c_checkout/1 should fail without required params 'amount' in the recipient list item map" do
      details = [
        %{
          phoneNumber: 10,
          currencyCode: "KES",
          providerChannel: "525900",
          metadata: %{message: "I am here"}
        }
      ]

      {:error, message} = B2c.b2c_checkout(details)
      assert "The request is missing required member 'amount' in one of te recipients" = message
    end

    test "b2c_checkout/1 should fail without required params 'currencyCode' in the recipient list item map" do
      details = [
        %{
          phoneNumber: "254724540000",
          amount: 10,
          metadata: %{message: "I am here"}
        }
      ]

      {:error, message} = B2c.b2c_checkout(details)

      assert "The request is missing required member 'currencyCode' in one of te recipients" =
               message
    end

    test "b2c_checkout/1 should fail without required param 'metadata' is not a map" do
      details = [
        %{
          phoneNumber: "254724540000",
          amount: 10,
          currencyCode: "KES",
          metadata: "a string"
        }
      ]

      {:error, message} = B2c.b2c_checkout(details)
      assert "The required member 'metadata' must be a map in one of te recipients" = message
    end

    test "b2c_checkout/1 should fail without all the recepient in list being maps" do
      details = [
        %{
          phoneNumber: "254724540000",
          amount: 10,
          currencyCode: "KES",
          metadata: "a string"
        },
        [test: "this is a wrong body"]
      ]

      {:error, message} = B2c.b2c_checkout(details)
      assert "The requst body should be a list of map" = message
    end

    test "b2c_checkout/1 should fail without request body being a list" do
      details = %{
        phoneNumber: "254724540000",
        amount: 10,
        currencyCode: "KES",
        metadata: "a string"
      }

      {:error, message} = B2c.b2c_checkout(details)
      assert "The requst body should be a list of a map of recipients" = message
    end
  end
end
