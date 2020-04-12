defmodule AtEx.USSDTest do
  @moduledoc """
  This module holds unit tests for the functions in the USSD context
  use it to ensure the functions act consume inputs and produce the correct outputs
  """
  use ExUnit.Case
  alias AtEx.USSD
  doctest AtEx.USSD

  describe "build_response/2" do
    test "return tuple of :ok and message with content End to end the session" do
      {:ok, return_message} = USSD.build_response("good morning", :end)
      assert return_message == "END good morning"
    end

    test "given message and atom :cont, continues the session" do
      {:ok, return_message} = USSD.build_response("good morning", :cont)
      assert return_message == "CON good morning"
    end

    test "given the message, it continues with the session" do
      {:ok, return_message} = USSD.build_response("good morning")
      assert return_message == "CON good morning"
    end

    test "return tuple of :ok and message with content CON when given a title which is a string and a body which is a list of strings" do
      {:ok, return_message} =
        USSD.build_response("What do you want to order", [
          "Chips & Sausage",
          "Burger & Chips",
          "Rice & beans"
        ])

      assert return_message ==
               "CON What do you want to order\n1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans"
    end

    test "return tuple of :ok and message with content CON when given a title which is a string and a body which is a list of tuples" do
      {:ok, return_message} =
        USSD.build_response("What do you want to order", [
          {0, "Chips & Sausage"},
          {1, "Burger & Chips"},
          {2, "Rice & beans"}
        ])

      assert return_message ==
               "CON What do you want to order\n0. Chips & Sausage\n1. Burger & Chips\n2. Rice & beans"
    end
  end

  describe "build_response/1" do
    test "errors out if the list is empty" do
      assert {:error, _} = USSD.build_response([])
    end

    test "returns a tuple of :ok and message with content CON if given a list of strings" do
      {:ok, return_message} =
        USSD.build_response(["Chips & Sausage", "Burger & Chips", "Rice & beans"])

      assert return_message == "CON 1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans"
    end

    test "when given a list of strings, will generate numbers for the options in the list" do
      body = ["Chips & Sausage", "Burger & Chips", "Rice & beans"]

      {:ok, return_message} = USSD.build_response(body)

      assert Enum.any?(1..Enum.count(body), fn x -> String.contains?(return_message, "#{x}") end)
    end

    test "returns a tuple of :ok and message with content CON if given a list of tuple" do
      {:ok, return_message} =
        USSD.build_response([{0, "Chips & Sausage"}, {1, "Burger & Chips"}, {2, "Rice & beans"}])

      assert return_message == "CON 0. Chips & Sausage\n1. Burger & Chips\n2. Rice & beans"
    end

    test "numbering of the body content can be changed to your preference by passing the number together with the item as
  a tuple" do
      body = [{"i", "Chips & Sausage"}, {"ii", "Burger & Chips"}, {"iii", "Rice & beans"}]
      {:ok, return_message} = USSD.build_response(body)

      assert Enum.any?(["i", "ii", "iii"], fn x -> String.contains?(return_message, x) end)
    end
  end
end
