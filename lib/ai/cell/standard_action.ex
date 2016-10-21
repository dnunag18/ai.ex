defmodule AI.Cell.StandardAction do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent
  @behaviour AI.Cell

  def relay(charge, state) do
    subscribers = state.subscribers
    threshold = state.threshold
    num_subscribers = Enum.max([Enum.count(subscribers), 1])
    charge = Float.floor(charge / num_subscribers)
    # IO.puts "ganglion #{charge}"
    if charge >= threshold do
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, charge}))
      # Map.put(state, :charges, [])
    else
      state
    end
  end
end
