defmodule AI.Cell do
  @moduledoc """
  This is the main cell implementation.  The behavior of the cell can be
  configured by setting the required `:module` option when creating the cell.

  ## Cell Types
  As mentioned above you can configure the cell type to use by setting the
  `:module` option.

    * `AI.Cell.BizarroGraded` - excited by negative charges, relays positive
    * `AI.Cell.Count` - used to for testing to inspect output after specified
      activity
    * `AI.Cell.InhibitorGraded` - excited by positive charges, relays negative
    * `AI.Cell.Monitor` - used for relaying charges to a process.
    * `AI.Cell.StandardAction` - excited by positive charges, relays a static
      charge
    * `AI.Cell.StandardGraded` - excited by positive charges, relays positive

  ## Options
  You can set options to the cell by doing:

      {:ok, bipolar} = Cell.start(%{
        name: "bipolar",
        threshold: 10,
        module: Cell.StandardAction
      })

  Here is the full list of options:

    * `:action_potential` - defaults to `10` - used by `AI.Cell.StandardAction`.
    This value is the impulse value relayed when the cell is excited and
    sending an impulse
    * `:module` - required - See [Cell Types] above
    * `:multiplier` - after the charges accumulate to surpass the threshold,
    multiply the charge per subscriber times this constant
    * `:name` - a value used to identify the cell.  Helpful for debugging
    * `:threshold` - defaults to `0` - a threshold to check to see if the
    received charges surpass this value.  If they do, the cell will relay an
    impulse.
    * `:timeout` - defaults to `20` - amount of time in milliseconds to wait
    before summing up received charges and deciding if an impulse is needed.
    After the timeout ends, all charges are cleared.

  """
  use GenEvent

  defstruct [
    subscribers: [],
    threshold: 0.0,
    charges: [],
    multiplier: 1,
    module: nil,
    publishers: 0,
    action_potential: 10,
    timeout: 20,
    name: "-"
  ]

  def start(state \\ %{}) do
    state = Map.merge(%AI.Cell{}, state)
    {:ok, pid} = GenEvent.start_link
    :ok = GenEvent.add_handler(pid, AI.Cell, state)
    {:ok, pid}
  end

  def handle_call({:stimulate, charge}, state) do
    cell = self
    charges = Map.get(state, :charges)
    if Enum.count(charges) == 0 do
      Task.start(fn ->
        :timer.sleep(state.timeout)
        GenEvent.call(cell, AI.Cell, :impulse)
      end)
    end
    {
      :ok,
      nil,
      Map.put(
        state,
        :charges,
        [charge / Enum.max([state.publishers, 1]) | charges]
      )
    }
  end

  def handle_call(:impulse, state) do
    state.module.impulse(state)
  end

  def handle_call(:subscribers, state) do
    {:ok, state.subscribers, state}
  end

  def handle_call(:state, state) do
    {:ok, state, state}
  end

  def handle_call({:add_subscriber, subscriber}, state) do
    state = Map.put(state, :subscribers, [subscriber | state.subscribers])
    GenEvent.call(subscriber, __MODULE__, :publisher)
    {:ok, state.subscribers, state}
  end

  def handle_call(:publisher, state) do
    state = Map.put(state, :publishers, state.publishers + 1)
    {:ok, nil, state}
  end

  def subscribe(pub, sub) do
    GenEvent.call(pub, __MODULE__, {:add_subscriber, sub})
  end

  def stimulate(cell, charge) do
    Task.start(fn ->
      GenEvent.call(cell, __MODULE__, {:stimulate, charge})
    end)
  end

  def get_state(cell) do
    GenEvent.call(cell, __MODULE__, :state)
  end

end
