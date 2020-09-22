defmodule AtEx.Util do
  @moduledoc false

  @doc false
  @spec get_url(String.t(), String.t()) :: String.t()
  def get_url(live_url, sandbox_url) do
    cond do
      Application.get_env(:at_ex, :sandbox) === false -> live_url
      Application.get_env(:at_ex, :sandbox) === true -> sandbox_url
      true -> sandbox_url
    end
  end
end
