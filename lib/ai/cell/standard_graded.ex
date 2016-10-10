defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  @behaviour AI.Cell

  def relay(charge, state) do
    num_subscribers = Enum.count(state.subscribers)
    charge = Float.floor(charge / num_subscribers)
    # IO.puts "#{name} - #{charge}"
    # IO.puts "#{state.name} - #{charge} to - #{inspect state.subscribers}"
    if charge > state.threshold do
      Enum.each(state.subscribers, &GenEvent.notify(&1, {:stimulate, {charge, :os.timestamp}}))
    end
  end
end
