defmodule AI.Cell.BizarroGraded do
  @behaviour AI.Cell

  defstruct [subscribers: [], charge: 0.0]

  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardGraded{} end)
  end

  @doc """
  Stimulates cell with a charge.  For graded cells, charges are passed to subscribing cells
  on a gradient scale, i.e., there is no action potential.
  """
  def stimulate(cell, transmitter) do
    original_charge = get(cell, :charge)

    charge = original_charge + transmitter
    put(cell, :charge, charge)
    if original_charge == 0.0 do
      decay(cell)
    end
    {:ok, charge}
  end

  def subscribe(publisher, subscriber) do
    subscribers = get(publisher, :subscribers) ++ [subscriber]
    {put(publisher, :subscribers, subscribers), subscribers}
  end

  @doc """
  Get state data
  """
  def get(cell, key) do
    Agent.get(cell, &Map.get(&1, key))
  end

  defp put(cell, key, value) do
    # IO.puts "PUT #{key} #{value}"
    Agent.update(cell, &Map.put(&1, key, value))
  end

  defp decay(cell) do
    Task.Supervisor.start_child(AI.TaskSupervisor, fn ->
      decay_task(cell)
    end)
  end

  defp decay_task(cell) do
    charge = get(cell, :charge)
    case charge do
      0.0 -> %{}
      _ ->
        Agent.cast(cell, &publish(&1))
        put(cell, :charge, Float.floor(charge / 2))
        decay(cell)
    end
  end

  defp publish(state) do
    if Map.get(state, :subscribers) do
      Enum.each(Map.get(state, :subscribers), &stimulate(&1, -state.charge))
    end
    state
  end
end
