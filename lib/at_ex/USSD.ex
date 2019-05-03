defmodule AtEx.USSD do
    @moduledoc """
    This module handles building valid response for the Africas Talking USSD endpoint
    """

    @doc """
    This function accepts a list of string and proceeds to build a valid response for
    the AT API
    """
    @spec build_response(list(String.t())) :: {:ok, String.t()} | {:error, term()}
    def build_response(responses) do
        case responses do
            val when length(val) > 1  ->
                [title | responses ] = val

                title = "CON " <>  title

                list_resp =
                for i <- 0..length(responses) - 1, do:  "#{i + 1}. #{ Enum.at(responses, i)} "


            val when length(val) ==  1 ->
                resp = "END " <> hd(val)

                {:ok, resp}

            val when length(val) < 1  ->
                {:error, "Responses can't be empty"}
        end
    end
end


