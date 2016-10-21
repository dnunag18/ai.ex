defmodule AI.Cell.Count do
  use GenEvent

  def stimulate(charge, state) do
    IO.puts "stuffff, #{charge}"
    total = Map.get(state, :total_charge, [])
    state = Map.put(state, :hits, Map.get(state, :hits, 0) + 1)
    Map.put(state, :total_charge, [charge|total])
  end

  def handle_call(:state, state) do
    {:ok, state, state}
  end



  def start(state \\ %{}) do
    {:ok, pid} = GenEvent.start
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    pid
  end

end
