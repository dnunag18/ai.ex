defmodule AI.Cell.Count do

  use GenEvent

  def impulse(state) do
    charge = Enum.sum(state.charges)
    total = Map.get(state, :total_charge, [])
    state = Map.put(state, :hits, Map.get(state, :hits, 0) + 1)
    Map.put(state, :total_charge, [charge|total])
  end

end
