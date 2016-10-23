defmodule AI.Cell.Monitor do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent

  def impulse(state) do
    send(state.monitor, {state.x, state.y, Enum.sum(state.charges)})
    {:ok, nil, Map.put(state, :charges, [])}
  end
end
