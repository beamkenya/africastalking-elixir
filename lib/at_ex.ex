defmodule AtEx do
  @moduledoc """
  AtEx is an Elixir Wrapper for the Africas Talking Api

  Use this library to handle interaction with the Africas Talking API end points,
  It is most useful for
  - Consuming incoming events that have been parsed
  - Building valid responses
  """
  alias AtEx.{
    Gateway.Airtime
  }

  defdelegate send_airtime(map), to: Airtime
end
