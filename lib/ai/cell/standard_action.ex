defmodule AI.Cell.StandardAction do

  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """

  @behaviour AI.Cell

  defstruct [
    subscribers: [],
    charge: 0.0,
    input_charge: 0.0,
    threshold: 10,
    output: 20,
    impulse: &AI.Cell.StandardAction.impulse/3,
    name: "-"
  ]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardAction{} end)
  end

  def impulse(cell, charge, subscribers) do
    output = AI.Cell.get(cell, :output)
    if subscribers do
      Enum.each(subscribers, &AI.Cell.stimulate(&1, output))
    end

    # refractory period
    AI.Cell.put(cell, :charge, -Float.floor(output / 2))
  end
end
