defmodule AI.Cell do
  @moduledoc """
  Specifies the behavior of a cell
  """

  @doc """
  Starts a cell agent
  """
  @callback start_link() :: {Keyword.t, term}

  @doc """
  Subscribes subscriber cell to publisher cell
  """
  @callback subscribe(publisher :: Agent.t, subscriber :: Agent.t) :: {Keyword.t, term}

  @doc """
  Stimulates cell with a charge
  """
  @callback stimulate(cell :: Agent.t, transmitter :: integer) :: {Keyword.t}
end
