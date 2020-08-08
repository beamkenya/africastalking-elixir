defmodule AtEx.Gateway.Payments.Bank.ValidateTest do
  @moduledoc false

  use ExUnit.Case
  doctest AtEx.Gateway.Payments.Bank.Validate
  alias AtEx.Gateway.Payments.Bank.Validate

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{
              status: "Success",
              description: "Payment completed successfully"
            })
        }
    end)

    :ok
  end

  describe "Bank Validation" do
    test "bank_validate/1 should handle bank validation  successfully" do
      details = %{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795", otp: "password"}

      {:ok, result} = Validate.bank_validate(details)
      assert "Success" = result["status"]
    end

    test "bank_validate/1 should fail without required params 'transactionId'" do
      details = %{otp: "password"}

      {:error, message} = Validate.bank_validate(details)

      assert "The request is missing required member 'transactionId'" = message
    end

    test "bank_validate/1 should fail without required params 'otp'" do
      details = %{transactionId: "ATPid_a58b61dc2bf556ff9c4b16e9f6e40795"}

      {:error, message} = Validate.bank_validate(details)
      assert "The request is missing required member 'otp'" = message
    end
  end
end
