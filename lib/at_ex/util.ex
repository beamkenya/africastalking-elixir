defmodule AtEx.Util do
  @moduledoc """
  This module holds general helper functions i.e. they can be utilized by any module.
  Functions to transform maps were obtained from https://gist.github.com/kipcole9/0bd4c6fb6109bfec9955f785087f53fb . 
  """

  @doc """
  Converts the given enumerable into map whose keys are atoms
  ## Examples

      iex> AtEx.Util.into_atomized_map(%{a: "test"})
      %{a: "test"}

      iex> AtEx.Util.into_atomized_map(%{"a" => "test"})
      %{a: "test"}

      iex> AtEx.Util.into_atomized_map([a: "test"])
      %{a: "test"}

      iex> AtEx.Util.into_atomized_map([{:a, "test"}])
      %{a: "test"}

  """
  @spec into_atomized_map(Enumerable.t()) :: map()
  def into_atomized_map(enum) do
    enum
    |> Enum.into(%{})
    |> atomize_keys()
  end

  @doc """
  Convert  string keys to :atom keys
  """
  def atomize_keys(nil), do: nil

  # Structs don't do enumerable and anyway the keys are already atoms
  def atomize_keys(%{__struct__: _} = struct) do
    struct
  end

  def atomize_keys(%{} = map) do
    map
    |> Enum.map(fn
      {k, v} when is_atom(k) -> {k, atomize_keys(v)}
      {k, v} -> {String.to_atom(k), atomize_keys(v)}
    end)
    |> Enum.into(%{})
  end

  # Walk the list and atomize the keys of any map members
  def atomize_keys([head | rest]) do
    [atomize_keys(head) | atomize_keys(rest)]
  end

  def atomize_keys(not_a_map) do
    not_a_map
  end
end
