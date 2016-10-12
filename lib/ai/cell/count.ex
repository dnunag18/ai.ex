defmodule AI.Cell.Count do
  use GenEvent

  def handle_event({:stimulate, {charge, _}}, state) do
    Map.put(state, :hits, Map.get(state, :hits, 0) + 1)
    {:ok, state}
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
