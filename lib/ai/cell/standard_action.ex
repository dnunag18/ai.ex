defmodule AI.Cell.StandardAction do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent
  @behaviour AI.Cell

  def relay(charge, state) do
    subscribers = state.subscribers
    threshold = state.threshold
    num_subscribers = Enum.count(subscribers)
    if charge >= threshold do
      charge = Float.floor(charge / num_subscribers)
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, {charge, :os.timestamp}}))
    end
  end
end
