defmodule AI.Cell do
  @moduledoc """
  """
  use GenEvent
  defstruct [
    subscribers: [],
    threshold: 0.0,
    charges: [],
    module: nil,
    publishers: 0,
    name: "-"
  ]

  @callback relay(charge :: number, pid, name :: String.t) :: any

  def handle_event({:stimulate, {charge, ts} = transmitter}, state) do
    # if state.name == "ganglion" do
    #   IO.puts "#{state.name} - #{inspect charge}"
    # end
    state = accumulate_charges({charge/Enum.max([1,state.publishers]), ts}, state)
    charge = calculate_charge(state.charges, ts)
    state.module.relay(charge, state)
    {:ok, state}
  end

  def handle_call(:subscribers, state) do
    {:ok, state.subscribers, state}
  end

  def handle_call(:threshold, state) do
    {:ok, state.threshold, state}
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
    state = Map.merge(%__MODULE__{}, state)
    {:ok, pid} = GenEvent.start_link
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    {:ok, pid}
  end


  def accumulate_charges(transmitter, state) do
    # add transmitter to the charges
    charges = case Enum.count(state.charges) do
        5 ->
            [_|t] = state.charges
            t
        _ -> state.charges
    end
    Map.put(state, :charges, charges ++ [transmitter])
  end

  def calculate_charge(charges, now) do
    Enum.reduce(charges, 0, fn(el, sum) ->
      {t, ts} = el
      diff = :timer.now_diff(now, ts)
      # IO.puts "calc with #{diff}"
      val = cond do
        diff < 20000 -> t
        diff < 30000 -> t / 2
        diff < 40000 -> t / 4
        :true -> 0
      end
      # IO.puts "diff #{diff}"
      Enum.max([Enum.min([sum + val, 60]), -60])
    end)
  end
end
