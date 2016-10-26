defmodule AI.Cell.InhibitorGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """

  use GenEvent

  def impulse(state) do
    sum_charge = Enum.sum(state.charges)
    num_subscribers = Enum.count(state.subscribers)
    if num_subscribers do
      charge = Float.floor(sum_charge / num_subscribers)
      if charge > state.threshold do
        charge = charge * state.multiplier
        Enum.each(state.subscribers, &AI.Cell.stimulate(&1, -charge))
      end
    end
    {:ok, nil, Map.put(state, :charges, [])}
  end
end
