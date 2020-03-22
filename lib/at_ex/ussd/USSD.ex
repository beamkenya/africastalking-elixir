defmodule AtEx.USSD do
  @moduledoc ~S"""
  ## Overview

  USSD interation with the Africas Talking API is rather simple as documented in their
  [documentation](https://build.at-labs.io/docs/ussd%2Foverview).
  Whenever a user sends a USSD request, it is received by Africastalking which then sends it as a POST request
  to your application through the callback URL you specified. This callback URL is specified on the Africastalking
  dashboard, under USSD section.
  When you receive the request, you consume it as you deem fit then generate a response.

  To generate the response, you can use the function `AtEx.USSD.build_response/1` or `AtEx.USSD.build_response/2`.

  ## End session 
  If you want to end a USSD session you call the `AtEx.USSD.build_response/1` giving it a string and the :end. This will
  generate a string that indicates to Africastalking to end the current session while showing the provided
  string as the message to the user.

  ## Continue session when content is a string
  Incase you would like to cont with a USSD session, call the `AtEx.USSD.build_response/1`, 
  giving it a string only since it already takes in the :cont as its second parameter by default.

  To display a response that awaits user input you can give the function a title and a body. The title is
  considered as description or instruction of the body. The body in most cases is a list of options a user will
  choose from.

  ## Example
      iex> AtEx.USSD.build_response("What do you want to order", ["Chips & Sausage", "Burger & Chips", "Rice & beans"])
      {:ok, "CON What do you want to order\n1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans" }

  If you do not want to include a title of the response, give a list of strings to the function. The response will
  give back a string with the elements of the list labeled from 1 to the number of the last item

  ## Example
      iex> AtEx.USSD.build_response(["Chips & Sausage", "Burger & Chips", "Rice & beans"])
      {:ok, "CON 1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans" }

  The numbering of the body content can be changed to your preference by passing the number together with the item as
  a tuple. Once you use the tuple, all the elements of the list must be a tuple

  ## Example
      iex> body = [{0,"Chips & Sausage"}, {1, "Burger & Chips"}, {2, "Rice & beans"}]
      iex> AtEx.USSD.build_response(body)
      {:ok, "CON 0. Chips & Sausage\n1. Burger & Chips\n2. Rice & beans" }
  """

  @doc """
  Gives us back a session end or a list of elements to be displayed to the user.
  It expects a string, a list of strings or a list of tuples as its input. Empty list will return
  an error



  """

  @spec build_response(list(String.t())) :: {:ok, String.t()} | {:error, term()}
  def build_response([]), do: {:error, "Responses can't be empty"}

  def build_response(body) when is_list(body) do
    response = "CON " <> _build_body(body)
    {:ok, response}
  end

  @doc """
  Expected inputs
   * message
   * content body
   * intent(either :end or :cont)
  The function can take in either the message and the content body as a list or the message and the 
  intent as an atom.
  When given the content body(as the second argument) it returns  valid africastalking session continuation 
  with a message and  a list of options to the user

  When given the intent(as the second argument) as `:con`, it returns a valid africastalking session continuation
  with a message only, otherwise whe given `:end`, it returns a message to end the session.
  """

  def build_response(message, intent \\ :cont)

  @spec build_response(String.t(), list()) :: tuple()
  def build_response(title, body) when is_bitstring(title) and is_list(body) do
    response = "CON " <> title <> "\n" <> _build_body(body)
    {:ok, response}
  end

  @spec build_response(String.t(), atom()) :: tuple()
  def build_response(message, :end) when is_bitstring(message) do
    {:ok, "END #{message}"}
  end

  @spec build_response(String.t(), atom()) :: tuple()
  def build_response(message, :cont) when is_bitstring(message) do
    {:ok, "CON #{message}"}
  end

  defp _build_body([{_key, _val} | _t] = body) do
    Enum.map(body, fn {number, value} ->
      "#{number}. #{value}"
    end)
    |> Enum.join("\n")
  end

  defp _build_body(body) when is_list(body) do
    for(i <- 1..length(body), do: "#{i}. #{Enum.at(body, i - 1)}")
    |> Enum.join("\n")
  end
end
