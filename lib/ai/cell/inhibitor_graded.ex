defmodule AI.Cell.InhibitorGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent
  @behaviour AI.Cell

  def relay(charge, state) do
    subscribers = state.subscribers
    num_subscribers = Enum.count(subscribers)
    # IO.puts "#{state.name} - #{charge} thresh: #{state.threshold}"
    if charge > state.threshold do
      # IO.puts "#{state.name} - #{charge} thresh: #{state.threshold}"
      charge = Float.floor(charge / num_subscribers)
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, {-charge, :os.timestamp}}))
    end
  end
end
