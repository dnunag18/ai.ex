defmodule AI.Cell do
  @moduledoc """
  """
  use GenEvent
  defstruct [
    subscribers: [],
    threshold: 0.0,
    charges: [],
    multiplier: 1,
    module: nil,
    publishers: 0,
    type: :graded, # graded | action
    timeout: 15,
    name: "-"
  ]

  @callback impulse(subscriber :: term, charge :: number) :: any

  def handle_call({:stimulate, charge}, state) do
    # IO.puts("stimulating #{state.name} with #{charge}")
    cell = self
    charges = Map.get(state, :charges)
    if Enum.count(charges) == 0 do
      Task.start(fn ->
        :timer.sleep(state.timeout)
        AI.Cell.impulse(cell)
      end)
    end
    {:ok, nil, Map.put(state, :charges, [charge|charges])}
  end

  def handle_call(:subscribers, state) do
    {:ok, state.subscribers, state}
  end

  def handle_call(:impulse, state) do
    subscribers = state.subscribers
    num_subscribers = Enum.max([Enum.count(subscribers), 1])
    charge = Enum.sum(state.charges)
    charge = Float.floor(charge / num_subscribers)
    if charge > state.threshold do
      Enum.each(subscribers, &state.module.impulse(&1, charge))
    end
    {:ok, nil, Map.put(state, :charges, [])}
  end

  def handle_call(:state, state) do
    {:ok, state, state}
  end

  def handle_call({:add_subscriber, subscriber}, state) do
    state = Map.put(state, :subscribers, [subscriber|state.subscribers])
    GenEvent.call(subscriber, AI.Cell, :publisher)
    {:ok, state.subscribers, state}
  end

  def handle_call(:publisher, state) do
    state = Map.put(state, :publishers, state.publishers + 1)
    {:ok, state.publishers, state}
  end

  def handle_call(:name, state) do
    {:ok, state.name, state}
  end

  def start(state \\ %{}) do
    state = Map.merge(%AI.Cell{}, state)
    {:ok, pid} = GenEvent.start_link
    :ok = GenEvent.add_handler(pid, AI.Cell, state)
    {:ok, pid}
  end

  def subscribe(pub, sub) do
    GenEvent.call(pub, __MODULE__, {:add_subscriber, sub})
  end

  def stimulate(cell, charge) do
    GenEvent.call(cell, __MODULE__, {:stimulate, charge})
  end

  def impulse(cell) do
    GenEvent.call(cell, __MODULE__, :impulse)
  end

  def get_state(cell) do
    GenEvent.call(cell, __MODULE__, :state)
  end

end
