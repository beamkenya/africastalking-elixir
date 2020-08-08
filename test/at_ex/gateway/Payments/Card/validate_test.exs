defmodule AtEx.Gateway.Payments.Card.ValidateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest AtEx.Gateway.Payments.Card.Validate

  alias AtEx.Gateway.Payments.Card.Validate

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body: %{
            status: "Success",
            description: "Payment completed successfully",
            checkoutToken: "ATCdTkn_SampleCdTknId123"
          }
        }
    end)

    :ok
  end

  describe "Card Validation" do
    test "card_validate/1 should handle card validation  successfully" do
      details = %{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795", otp: "password"}

      {:ok, result} = Validate.card_validate(details)
      assert "Success" = result.status
    end

    test "card_validate/1 should fail without required params 'transactionId'" do
      details = %{otp: "password"}

      {:error, message} = Validate.card_validate(details)

      assert "The request is missing required member 'transactionId'" = message
    end

    test "card_validate/1 should fail without required params 'otp'" do
      details = %{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795"}

      {:error, message} = Validate.card_validate(details)
      assert "The request is missing required member 'otp'" = message
    end
  end
end
