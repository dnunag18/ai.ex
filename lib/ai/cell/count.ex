defmodule AI.Cell.Count do

  @behaviour AI.Cell

  def stimulate(charge, state) do
    total = Map.get(state, :total_charge, [])
    state = Map.put(state, :hits, Map.get(state, :hits, 0) + 1)
    Map.put(state, :total_charge, [charge|total])
  end
end
