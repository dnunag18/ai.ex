defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """

  defstruct [subscribers: [], charge: 0.0, publish: &AI.Cell.StandardGraded.publish/1]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardGraded{} end)
  end

  def publish(state) do
    subscribers = state.subscribers
    charge = state.charge
    if subscribers do
      Enum.each(subscribers, &AI.Cell.stimulate(&1, charge))
    end
    state
  end
end
