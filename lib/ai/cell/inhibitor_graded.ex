defmodule AI.Cell.InhibitorGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent
  @behaviour AI.Cell

  def relay(charge, state) do
    subscribers = state.subscribers
    num_subscribers = Enum.max([Enum.count(subscribers), 1])
    charge = Float.floor(charge / num_subscribers)

    if charge > state.threshold do
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, -charge}))
    end
    state
  end
end
