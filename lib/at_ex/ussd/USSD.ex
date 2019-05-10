defmodule AtEx.USSD do
  @moduledoc """
  ## Overview 

  USSD interation with the Africas Talking API is rather simple as documented in their 
  [documentation](https://build.at-labs.io/docs/ussd%2Foverview). 
  As explained whenever a USSD request is sent to an application a post request will be sent to the application, 
  It will be the duty of the developer to consume this request as they deem fit and generate a list of responses 
  please note

  1. A list with a single item will be considered a termination of the conversation and prepended with `END`
  2. A list with more than one item will be considered a title with at least one choice i.e the first item 
  will be considered the title of the menu and the items from second and onward will be considered choices for 
  the user, choices will be ordered according to their position in the input list.
  """

  @doc """
  Given a list of responses generate a valid Africas Talking USSD response string

  ## Parameters 
  - responses: A list of string to server as the respise parameters

  ## Examples 

      iex> AtEx.USSD.build_response(["What meal would you like", "Chips & Sausage", "Burger & Chips", "Rice & beans"])
      {:ok, "CON What meal would you like \n 1. Chips & Sausage \n 2. Burger & Chips \n 3. Rice & beans"}

      iex> AtEx.USSD.build_response(["Thank you for your business"])
      {:ok, "END Thank you for your business"}
  """
  @spec build_response(list(String.t())) :: {:ok, String.t()} | {:error, term()}
  def build_response(responses) do
    case responses do
      val when length(val) > 1 ->
        [title | responses] = val

        title = "CON " <> title

        numbered_answers =
          for i <- 0..(length(responses) - 1), do: "#{i + 1}. #{Enum.at(responses, i)}"

        response =
          [title | numbered_answers]
          |> Enum.join(" \n ")

        {:ok, response}

      val when length(val) == 1 ->
        resp = "END " <> hd(val)

        {:ok, resp}

      val when length(val) < 1 ->
        {:error, "Responses can't be empty"}
    end
  end
end
