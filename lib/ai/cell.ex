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

    charge = original_charge + transmitter
    put(cell, :charge, charge)

    {:ok, pid} = case original_charge do
      0.0 -> start_decay_and_publish(cell)
      _ -> {:ok, nil}
    end
    {:ok, charge, pid}
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

  defp start_decay_and_publish(cell) do
    Task.Supervisor.start_child(AI.Supervisor, fn ->
      decay_and_publish_task(cell)
    end)
  end

  defp decay_and_publish_task(cell) do
    charge = get(cell, :charge)
    case charge do
      0.0 -> {:ok}
      _ ->
        put(cell, :charge, Float.floor(charge / 2))
        publish = get(cell, :publish)
        publish.(cell)
        Tuple.append(
          {get(cell, :charge)},
          start_decay_and_publish(cell)
        )
    end
  end



  @doc """
  Publishes a charge to the subscribing cells.  This is called during the `stimulate/2` method
  """
  @callback publish(cell :: term) :: term
end
