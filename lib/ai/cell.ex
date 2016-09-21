defmodule AI.Cell do
  @moduledoc """
  """

  @doc """
  Stimulates cell with a charge.  For graded cells, charges are passed to subscribing cells
  on a gradient scale, i.e., there is no action potential.
  """
  @spec stimulate(Agent.t, integer) :: {Keyword.t, term}
  def stimulate(cell, transmitter) do
    original_charge = get(cell, :charge)

    charge = original_charge + transmitter
    put(cell, :charge, charge)
    if original_charge == 0.0 do
      decay(cell)
    end
    {:ok, charge}
  end

  @spec stimulate(Agent.t, Agent.t) :: {:ok, Enum.t}
  def subscribe(publisher, subscriber) do
    subscribers = get(publisher, :subscribers) ++ [subscriber]
    {put(publisher, :subscribers, subscribers), subscribers}
  end

  @doc """
  Get cell's state for the specified key
  """
  @spec get(Agent.t, atom) :: term
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
        Agent.cast(cell, get(cell, :publish))
        put(cell, :charge, Float.floor(charge / 2))
        decay(cell)
    end
  end
end
