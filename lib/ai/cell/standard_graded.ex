defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """

  @behaviour AI.Cell

  defstruct [
    subscribers: [],
    charge: 0.0,
    input_charge: 0.0,
    impulse: &AI.Cell.StandardGraded.impulse/3,
    threshold: 0.0,
    name: "-"
  ]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardGraded{} end)
  end

  def impulse(_, charge, subscribers) do
    if subscribers do
      Enum.each(subscribers, &AI.Cell.stimulate(&1, charge))
    end
  end
end
