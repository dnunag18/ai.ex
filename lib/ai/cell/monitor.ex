defmodule AI.Cell.Monitor do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent

  def handle_event({:stimulate, {charge, _}}, state) do
    send(state.monitor, {state.x, state.y, charge})
    {:ok, state}
  end

  def start(state \\ %{x: nil, y: nil, monitor: nil}) do
    {:ok, pid} = GenEvent.start
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    pid
  end
end
