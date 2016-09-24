defmodule AI.Cell do
  require Logger
  @moduledoc """
  """

  @doc """
  Stimulates cell with a charge.  For graded cells, charges are passed to subscribing cells
  on a gradient scale, i.e., there is no action potential.

  When `stimulate`-ing a cell, the accept, decay, publish task chain is initiated.
  * The transmitter charge is added to the `input_charge` of the cell.
  * The input charges are added to the `charge`
  * The `charge` decays
  * The cell publishes the charge to the subscribers
  """
  @spec stimulate(Agent.t, integer) :: {Keyword.t, term, term, term}
  def stimulate(cell, transmitter) do
    Logger.debug "stimulate #{inspect cell} #{transmitter}"
    input_charge = get(cell, :input_charge)
    charge = get(cell, :charge)

    put(cell, :input_charge, input_charge + transmitter)

    task = case {charge, input_charge} do
      {0.0, 0.0} -> start_accept_decay_publish(cell)
      _ -> nil
    end

    {:ok, task}
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

  @doc """
  Update cell's state for the specified key.  Use carefully
  """
  def put(cell, key, value) do
    Agent.update(cell, &Map.put(&1, key, value))
  end

  defp start_accept_decay_publish(cell) do
    Task.Supervisor.async(AI.Supervisor, fn ->
      charge = accept_decay_publish(cell)

      # continue task chain if there is still any charges
      if charge > 0.0 do
        start_accept_decay_publish(cell)
      end

      charge
    end)
  end

  defp accept_decay_publish(cell) do
    accept(cell)
    decay(cell)
    publish(cell)
    get(cell, :charge)
  end

  defp accept(cell) do
    charge = get(cell, :charge)
    input_charge = get(cell, :input_charge)
    Logger.debug "accept #{inspect cell} #{input_charge} -> #{charge}"
    put(cell, :charge, charge + input_charge)
    put(cell, :input_charge, 0.0)
  end

  defp decay(cell) do
    charge = get(cell, :charge)
    Logger.debug "decay #{inspect cell} #{charge}"
    put(cell, :charge, Float.floor(charge / 2))
  end

  defp publish(cell) do
    charge = get(cell, :charge)
    threshold = get(cell, :threshold)
    Logger.debug "publish #{inspect cell} #{charge}"
    if charge >= threshold do
      impulse = get(cell, :impulse)
      subscribers = get(cell, :subscribers)
      if Enum.count(subscribers) > 0 do
        charge = Float.floor(charge / Enum.count(subscribers))
        impulse.(cell, charge, subscribers)
      end
    end
  end

  @doc """
  Publishes a charge to the subscribing cells.  This is called in the publish phase of the accept, decay, publish task chain
  """
  @callback impulse(cell :: Agent.t, charge :: Float.t, subscribers :: List.t) :: term
end
