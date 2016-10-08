defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  @behaviour AI.Cell

  def relay(charge, pid, name \\ "unknown") do
    subscribers = GenEvent.call(pid, AI.Cell, :subscribers)
    num_subscribers = Enum.count(subscribers)
    charge = Float.floor(charge / num_subscribers)
    # IO.puts "#{name} - #{charge}"
    if charge > 0 do
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, {charge, :os.timestamp}}))
    end
  end
end
