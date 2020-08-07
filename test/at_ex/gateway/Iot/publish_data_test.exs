defmodule AtEx.Gateway.Iot.PublishDataTest do
  use ExUnit.Case
  doctest AtEx.Gateway.Airtime
  alias AtEx.Gateway.Iot.PublishData

  setup do
    Tesla.Mock.mock(fn
      %{method: :post} ->
        %Tesla.Env{
          status: 201,
          body:
            Jason.encode!(%{"description" => "Message processed successfully", "status" => true})
        }
    end)

    :ok
  end

  describe "IOT Publish data" do
    test "publish/1 should publish data to a device" do
      # make message details
      publish_details = %{
        deviceGroup: "CrazyCats",
        topic: "any-topic",
        payload: "take me to your leader"
      }

      # run details through our code
      {:ok, result} = PublishData.publish(publish_details)

      # assert our code gives us a single element list of messages
      msg = result["description"]

      # assert that message details correspond to details of set up message
      assert msg == "Message processed successfully"
    end
  end

  describe "fails" do
    setup do
      Tesla.Mock.mock(fn
        %{method: :post} ->
          %Tesla.Env{
            status: 400,
            body:
              "The request content was malformed:\nObject is missing required member 'payload'"
          }
      end)

      :ok
    end

    test "publish/1 should error out if payload is missing" do
      # make message details
      publish_details = %{deviceGroup: "CrazyCats", topic: "any-topic"}

      # run details through our code
      {:error, result} = PublishData.publish(publish_details)

      assert result.status == 400

      # assert that message details correspond to details of set up message
      assert result.message ==
               "The request content was malformed:\nObject is missing required member 'payload'"
    end
  end
end
