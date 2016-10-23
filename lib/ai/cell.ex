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
    action_potential: 10,
    type: :graded, # graded | action
    timeout: 20,
    name: "-"
  ]


  def handle_call({:stimulate, charge}, state) do
    cell = self
    charges = Map.get(state, :charges)
    if Enum.count(charges) == 0 do
      Task.start(fn ->
        :timer.sleep(state.timeout)
        GenEvent.call(cell, AI.Cell, :impulse)
      end)
    end
    # if state.name == "ganglion" do
    #   IO.puts "charge #{charge} - pubs: #{state.publishers} #{inspect state.charges}"
    # end
    {
      :ok,
      nil,
      Map.put(
        state,
        :charges,
        [charge / Enum.max([state.publishers, 1]) |charges]
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
    Task.start(fn ->
      GenEvent.call(cell, __MODULE__, {:stimulate, charge})
    end)
  end

  def get_state(cell) do
    GenEvent.call(cell, __MODULE__, :state)
  end

end
