defmodule AtEx.Gateway.ApplicationTest do
  @moduledoc """
  This module holds unit tests for the functions in the Application gateway
  """
  use ExUnit.Case
  alias AtEx.Gateway.Application

  setup do
    Tesla.Mock.mock(fn
      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body: Jason.encode!(%{"UserData" => %{"balance" => "ZAR -1.3448"}})
        }
    end)

    :ok
  end

  describe "Application Endpint Tests" do
    test "fetches application data" do
      {:ok, result} = Application.get_data()
      assert result["UserData"]
    end
  end
end
