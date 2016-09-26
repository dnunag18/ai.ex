defmodule AI.Cell.Debug.Logger do
  @moduledoc """
  Logger Cell.  Prints out the charge value and time the charge was transmitted.
  This is meant for debugging and testing purposes, but may be used for other
  purposes
  """

  require Logger

  defstruct [
    subscribers: [],
    charge: 0.0,
    input_charge: 0.0,
    impulse: &AI.Cell.Debug.Logger.impulse/3,
    threshold: 0.0,
    name: "logger",
    stimulator: &AI.Cell.Debug.Logger.stimulator/2
  ]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.Debug.Logger{} end)
  end

  def impulse(_, _, _) do
    IO.puts "do nothing"
  end

  def stimulator(cell, transmitter) do
    Logger.info "#{inspect cell} - transmitted #{transmitter}"
  end
end
