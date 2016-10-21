defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  @behaviour AI.Cell
  use GenEvent

  def stimulate(charge, state) do
    cell = self
    charges = Map.get(state, :charges)
    if Enum.count(charges) == 0 do
      Task.start(fn ->
        :timer.sleep(state.timeout)
        AI.Cell.impulse(cell)
      end)
    end
    Map.put(state, :charges, [charge|charges])
  end

  def relay(charge, state) do
    subscribers = state.subscribers
    num_subscribers = Enum.max([Enum.count(subscribers), 1])
    charge = Float.floor(charge / num_subscribers)
    if charge > state.threshold do
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, charge}))
    end
    state
  end
end
