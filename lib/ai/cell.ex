defmodule AI.Cell do
  require Logger
  @moduledoc """
  """

  @doc """
  Stimulates cell with a charge.  For graded cells, charges are passed to subscribing cells
  on a gradient scale, i.e., there is no action potential.
  """
  @spec stimulate(Agent.t, integer) :: {Keyword.t, term, term}
  def stimulate(cell, transmitter) do
    original_charge = get(cell, :charge)
    decay_task = nil

    charge = original_charge + transmitter
    put(cell, :charge, charge)
    decay_task = if original_charge == 0.0 do
      decay(cell)
    end
    {:ok, charge, decay_task}
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
        publish = get(cell, :publish)
        publish.(get(cell, :subscribers), charge)
        put(cell, :charge, Float.floor(charge / 2))
        decay(cell)
    end
  end



  @doc """
  Publishes a charge to the subscribing cells.  This is called during the `stimulate/2` method
  """
  @callback publish(cell :: term) :: nil
end
