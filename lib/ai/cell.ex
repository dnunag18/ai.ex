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
    Agent.get_and_update(cell, fn(state) ->
      charges = state.charge ++ transmitter
      {charges, Map.put(cell, :charge, charges)}
    end)
  end

  @spec subscribe(Agent.t, Agent.t) :: {:ok, Enum.t}
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

  defp start_decayer(cell) do
    Task.start_nolink(decay_and_relay(cell))
  end

  defp decay_and_relay(cell) do
    fn ->
      # get charge
      charges = Agent.get_and_update(cell, fn(state) ->
        charges = state.charges ++ transmitter
        {charges, []}
      end)

      # relay charge
      threshold = get(cell, :threshold)
      sum_charge = Enum.reduce(charges, &(&1 + &2))

      if sum_charge >= threshold && sum_charge != 0.0 do
        # get subscribers, and call stimulate on them
        subscribers = get(cell, :subscribers)
        Enum.each(
          subscribers,
          fn ->
            Task.start(fn ->
              stimulate(cell, sum_charge)
            end)
          end
        )


        # decay
        decayed_charge = case {sum_charge > 0, sum_charge < 0} do
          {:true, _} -> Float.floor(sum_charge / 2)
          {_, :true} -> Float.ceil(sum_charge / 2)
          _ -> sum_charge
        end


        # put back decayed charge
        Agent.get_and_update(
          cell,
          fn(state) ->
            charges = state.charges
            {charges, charges ++ [decayed_charge]}
          end
        )

        decay_and_relay(cell).()
      end
    end
  end

  @doc """
  Publishes a charge to the subscribing cells.  This is called in the publish phase of the accept, decay, publish task chain
  """
  @callback impulse(cell :: Agent.t, charge :: Float.t, subscribers :: List.t) :: term
end
