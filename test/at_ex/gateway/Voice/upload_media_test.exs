defmodule AtEx.Gateway.Voice.UploadMediaTest do
  @moduledoc """
  This module holds unit tests for the functions in the SMS gateway
  """
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias AtEx.Gateway.Voice.UploadMedia

  @attr "username="

  describe "Queue Status" do
    setup do
      mock(fn
        %{method: :post, body: @attr} ->
          %Tesla.Env{
            status: 400,
            body: "Request is missing required form field 'phoneNumber'"
          }

        %{method: :post} ->
          %Tesla.Env{
            status: 201,
            body: "The request has been fulfilled and resulted in a new resource being created."
          }
      end)

      :ok
    end

    test "upload/1 should upload media with required parameters" do
      upload_media_details = %{
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        phoneNumber: "+254728833180"
      }

      {:ok, result} = UploadMedia.upload(upload_media_details)

      assert result ==
               "The request has been fulfilled and resulted in a new resource being created."
    end
  end

  describe "Call without a 'phoneNumber' parameter  " do
    setup do
      mock(fn
        %{method: :post} ->
          %Tesla.Env{
            status: 400,
            body: "Request is missing required form field 'phoneNumber'"
          }
      end)

      :ok
    end

    test "upload/1 should error out without phoneNumber parameter" do
      bad_details = %{url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"}
      {:error, result} = UploadMedia.upload(bad_details)

      assert "Request is missing required form field 'phoneNumber'" = result.message

      assert result.status == 400
    end
  end

  describe "Call without a 'url' parameter  " do
    setup do
      mock(fn
        %{method: :post} ->
          %Tesla.Env{
            status: 400,
            body: "Request is missing required form field 'url'"
          }
      end)

      :ok
    end

    test "upload/1 should error out without phoneNumber parameter" do
      bad_details = %{phoneNumber: "+254728833180"}
      {:error, result} = UploadMedia.upload(bad_details)

      assert "Request is missing required form field 'url'" = result.message

      assert result.status == 400
    end
  end
end
