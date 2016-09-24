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
    publish: &AI.Cell.StandardAction.publish/1
  ]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardAction{} end)
  end

  def publish(cell) do
    [charge, subscribers] = Enum.map(
      [:charge, :subscribers],
      &AI.Cell.get(cell, &1)
    )
    if subscribers do
      Enum.each(subscribers, &AI.Cell.stimulate(&1, charge))
    end
  end
end
