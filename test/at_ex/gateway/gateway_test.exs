defmodule AtEx.GatewayTest do
  @moduledoc """
    This module holds test for the HTTP gateway that runs calls against the Africa's Talking API
  """
  use ExUnit.Case
  import Tesla.Mock

  alias AtEx.{
    Gateway
  }

  setup do
    mock(fn
      # body is either of the URL's
      %{method: :post, body: body} ->
        with body do
          json(%{"username" => "username", "to" => "+254720560202", "message" => "message"})
        end

      %{method: :get} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "result" => %{
                "username" => "username",
                "to" => "+254720560202",
                "message" => "message"
              }
            })
        }
    end)

    :ok
  end

  @params %{username: "username", to: "+254720560202", message: "message"}

  describe "gateway context" do
    test "send_sms/1 sends out SMSes" do
    end
  end
end
