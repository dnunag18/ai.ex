defmodule AI.Cell.InhibitorGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent
  @behaviour AI.Cell

  def relay(charge, pid, name \\ "unknown") do
    subscribers = GenEvent.call(pid, AI.Cell, :subscribers)
    num_subscribers = Enum.count(subscribers)
    # IO.puts "#{name} - #{charge} - #{num_subscribers}"
    if charge > 0 do
      charge = Float.floor(charge / num_subscribers)
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, {-charge, :os.timestamp}}))
    end
  end
end
