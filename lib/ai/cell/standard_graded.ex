defmodule AI.Cell.StandardGraded do
  @moduledoc """
  This cell relays positive charges when excited by positive charges
  """

  def impulse(state) do
    sum_charge = Enum.sum(state.charges)
    num_subscribers = Enum.count(state.subscribers)
    if num_subscribers > 0 do
      charge = Float.floor(sum_charge / num_subscribers)
      if charge > state.threshold do
        charge = charge * state.multiplier
        Enum.each(state.subscribers, &AI.Cell.stimulate(&1, charge))
      end
    end
    {:ok, nil, Map.put(state, :charges, [])}
  end

end
