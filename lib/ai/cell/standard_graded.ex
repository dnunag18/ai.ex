defmodule AI.Cell.StandardGraded do
  @behaviour AI.Cell

  defstruct [subscribers: [], charge: 0.0]

  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardGraded{} end)
  end

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

  def get(cell, key) do
    Agent.get(cell, &Map.get(&1, key))
  end

  defp put(cell, key, value) do
    # IO.puts "PUT #{key} #{value}"
    Agent.update(cell, &Map.put(&1, key, value))
  end

  def decay(cell) do
    Task.Supervisor.start_child(AI.TaskSupervisor, fn ->
      decay_task(cell)
    end)
  end

  def decay_task(cell) do
    charge = get(cell, :charge)
    case charge do
      0.0 -> %{}
      _ ->
        Agent.cast(cell, &publish(&1))
        put(cell, :charge, Float.floor(charge / 2))
        decay(cell)
    end
  end

  def publish(cell) do
    if Map.get(cell, :subscribers) do
      Enum.each(Map.get(cell, :subscribers), &stimulate(&1, cell.charge))
    end
    cell
  end
end
