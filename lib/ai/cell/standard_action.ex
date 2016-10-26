defmodule AI.Cell.StandardAction do
  @moduledoc """
  This cell relays positive charges when excited by positive charges, but
  the charges have to reach a certain threshold, and whenever activated, this
  cell will always send the same charge specified by `:action_potential`.  You
  may also configure the threshold with `:threshold`
  """

  def impulse(state) do
    sum_charge = Enum.sum(state.charges)
    num_subscribers = Enum.count(state.subscribers)
    if num_subscribers do
      charge = Float.floor(sum_charge / num_subscribers)
      if charge > state.threshold do
        Enum.each(
          state.subscribers,
          &AI.Cell.stimulate(&1, state.action_potential)
        )
      end
    end
    {:ok, nil, Map.put(state, :charges, [])}
  end
end
