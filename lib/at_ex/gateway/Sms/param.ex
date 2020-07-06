defmodule AtEx.Gateway.Sms.Param do
  @moduledoc """
  This module defines the struct for the sms params to be sent out to AT. 
  All the keys are as documented in their docs: https://build.at-labs.io/docs/sms%2Fsending%2Fbulk
  """
  @enforce_keys [:to, :message]

  defstruct [
    :username,
    :to,
    :from,
    :message,
    :bulkSMSMode,
    :enqueue,
    :keyword,
    :linkId,
    :retryDurationInHours
  ]

  @type t :: %__MODULE__{
          username: String.t(),
          to: String.t(),
          from: String.t(),
          message: String.t(),
          bulkSMSMode: non_neg_integer,
          enqueue: non_neg_integer,
          keyword: String.t(),
          linkId: String.t(),
          retryDurationInHours: non_neg_integer
        }

  @doc """
  Validates the given attributes agaist the Param struct. 
  The attributes are first converted into a `map()` with `atom()` keys first before being used
  If successful, it returns a `map()` containing only the fields in attributes given.
  It raises an excetion if any of the validations fails. 

  ## Validations
  | Key | Required  | min length |
  |-------|------- | ------ |
  | `:to` | `true` |  `3`
  | `:message` | `true` | `1` |

  ### NOTE: 
  Before validating the length, the argument is first trimmed to remove leading and padding spaces.

  ## Examples
        iex> AtEx.Gateway.Sms.Param.harmonize(%{})
        ** (RuntimeError)     `to` must be at least `3` characters
        
        iex> AtEx.Gateway.Sms.Param.harmonize(%{to: "334", message: " "})
        ** (RuntimeError)     `message` must be at least `1` characters

        iex> AtEx.Gateway.Sms.Param.harmonize(%{to: "334", message: "hello"})
        %{message: "hello", to: "334"}

        iex> AtEx.Gateway.Sms.Param.harmonize(%{to: "334", message: "hello", non_existent: "baa"})
        ** (KeyError) key :non_existent not found in: %AtEx.Gateway.Sms.Param{bulkSMSMode: nil, 
        enqueue: nil, from: nil, keyword: nil, linkId: nil, message: "hello", retryDurationInHours: nil, to: nil, username: nil}

  """
  @spec harmonize(Enumerable.t()) :: map()
  def harmonize(attrs) do
    attrs = AtEx.Util.into_atomized_map(attrs)

    __MODULE__
    |> struct!(attrs)
    |> validate_length(to: 3, message: 1)
    |> Map.take(Map.keys(attrs))
  end

  defp validate_length(%_{} = param, [{key, length} | other_fields]) do
    param
    |> validate_length(key, length)
    |> validate_length(other_fields)
  end

  defp validate_length(%_{} = param, []), do: param

  defp validate_length(%_{} = param, key, length) do
    value = param |> Map.get(key) |> String.trim()

    if byte_size(value) >= length do
      param
    else
      raise """
          `#{key}` must be at least `#{length}` characters
      """
    end
  end
end
