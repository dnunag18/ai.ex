defmodule AI.Cell.Monitor do
  @moduledoc """
  This cell type is used for retrieving the output of a cell or nucleus.
  It sends the location and charges to the process specified in `:monitor` when
  stimulated.
  """

  def impulse(state) do
    send(state.monitor, {state.x, state.y, Enum.sum(state.charges)})
    {:ok, nil, Map.put(state, :charges, [])}
  end
end
