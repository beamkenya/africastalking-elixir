defmodule AtEx.Util do
  @moduledoc false

  @doc false
  @spec get_url(String.t(), String.t()) :: String.t()
  def get_url(live_url, sandbox_url) do
    cond do
      Mix.env() == :prod -> live_url
      Application.get_env(:at_ex, :force_live_url) == "YES" -> live_url
      true -> sandbox_url
    end
  end
end
