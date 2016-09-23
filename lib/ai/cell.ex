defmodule AI.Cell do
  require Logger
  @moduledoc """
  """

  @doc """
  Stimulates cell with a charge.  For graded cells, charges are passed to subscribing cells
  on a gradient scale, i.e., there is no action potential.
  """
  @spec stimulate(Agent.t, integer) :: {Keyword.t, term, term, term}
  def stimulate(cell, transmitter) do
    original_charge = get(cell, :charge)

    charge = original_charge + transmitter
    put(cell, :charge, charge)

    {decay_task, publish_task} = case original_charge do
      0.0 -> start_decay_and_publish(cell)
      _ -> {nil, nil}
    end
    {:ok, charge, decay_task, publish_task}
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
    decay = Task.Supervisor.async(AI.Supervisor, fn ->
      start_decay(cell)
    end)
    publish = Task.Supervisor.async(AI.Supervisor, fn ->
      start_publish(cell)
    end)
    {decay, publish}
  end

  defp start_decay(cell) do
    charge = get(cell, :charge)
    case charge do
      0.0 -> 0
      _ ->
        put(cell, :charge, Float.floor(charge / 2))
        start_decay_and_publish(cell)
        get(cell, :charge)
    end
  end

  defp start_publish(cell) do
    charge = get(cell, :charge)
    if charge >= get(cell, :threshold) do
      publish = get(cell, :publish)
      publish.(cell)
    else
      {:not_published, charge}
    end
  end

  @doc """
  Publishes a charge to the subscribing cells.  This is called during the `stimulate/2` method
  """
  @callback publish(cell :: term) :: {atom, term}
end
