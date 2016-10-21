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
    timeout: 5,
    name: "-"
  ]

  @callback relay(charge :: number, state :: term) :: any

  def handle_call({:stimulate, charge}, state) do
    state = state.module.stimulate(charge, state)
    {:ok, nil, state}
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
      Enum.each(subscribers, &GenEvent.call(&1, __MODULE__, {:stimulate, charge}))
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

  def accumulate_charges(transmitter, state) do
    # add transmitter to the charges
    charges = case Enum.count(state.charges) do
        10 ->
            [_|t] = state.charges
            t
        _ -> state.charges
    end
    Map.put(state, :charges, charges ++ [{transmitter, :os.timestamp}])
  end

  def calculate_charge(charges) do
    now = :os.timestamp
    Enum.reduce(charges, 0, fn(el, sum) ->
      {t, ts} = el
      diff = :timer.now_diff(now, ts)
      val = cond do
        diff < 30000 -> t
        diff < 60000 -> t / 2
        diff < 90000 -> t / 4
        :true -> 0
      end
      Enum.max([Enum.min([sum + val, 60]), -60])
    end)
  end

  def timer(cell) do
    state = GenEvent.call(cell, AI.Cell, :state)
    if state != nil do
      charge = calculate_charge(Map.get(state, :charges, []))

      # if state.name == "out_to_in" do
      #   IO.puts "stuff #{state.name} #{charge} -- #{inspect state.charges}"
      # end
      state.module.relay(charge * state.multiplier, state)
      :timer.sleep(20)
      if Process.alive? cell do
        timer(cell)
      end
    end
  end
end
