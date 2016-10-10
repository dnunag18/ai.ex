defmodule AI.Cell do
  @moduledoc """
  """
  use GenEvent
  defstruct [
    subscribers: [],
    threshold: 0.0,
    charges: [],
    module: nil,
    name: "-"
  ]

  @callback relay(charge :: number, pid, name :: String.t) :: any

  def handle_event({:stimulate, {charge, ts} = transmitter}, state) do
    # IO.puts "#{state.name} - #{inspect charge}"
    state = accumulate_charges(transmitter, state)
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
    {:ok, state.subscribers, state}
  end

  def handle_call(:name, state) do
    {:ok, state.name, state}
  end

  def start(state \\ %{}) do
    state = Map.merge(%__MODULE__{}, state)
    {:ok, pid} = GenEvent.start
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
        diff < 10000 -> t
        diff < 20000 -> t / 2
        diff < 30000 -> t / 4
        :true -> 0
      end
      # IO.puts "diff #{diff}"
      Enum.max([Enum.min([sum + val, 10]), -10])
    end)
  end
end
