defmodule AtEx.Gateway.Payments.Mobile.CheckoutTest do
  @moduledoc false

  use ExUnit.Case
  alias AtEx.Gateway.Payments.Mobile.Checkout

  @attr "username="

  setup do
    Tesla.Mock.mock(fn
      %{method: :post, body: @attr} ->
        %Tesla.Env{
          status: 400,
          body: "Request is missing required form field 'to'"
        }

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
end
