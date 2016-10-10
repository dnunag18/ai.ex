defmodule AI.Cell do
  @moduledoc """
  """
  use GenEvent
  defstruct [
    subscribers: [],
    threshold: 0.0,
    name: "-"
  ]

  @callback relay(charge :: number, pid, name :: String.t) :: any

  def handle_event({:stimulate, {charge, _}}, state) do
    # IO.puts "#{state.name} - #{inspect charge}"
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

  def start_link(module, state \\ %{}) do
    state = Map.merge(%__MODULE__{}, state)
    {:ok, pid} = GenEvent.start
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    task = start_processor(pid, module)

    {pid, task}
  end

  defp start_processor(pid, module) do
    name = GenEvent.call(pid, AI.Cell, :name)
    {:ok, task} = Task.start(fn ->
      GenEvent.stream(pid)
      |> Stream.transform(%{charges: []}, fn({:stimulate, transmitter}, acc) ->
        now = :os.timestamp
        acc = accumulate_charges(transmitter, acc)
        charge = calculate_charge(acc.charges, now)
        # IO.puts "#{name}-processing-#{inspect charge}"
        {[charge], acc}
      end)
      |> Enum.each(&module.relay(&1, pid, name))
    end)
    task
  end

  def accumulate_charges(transmitter, acc) do
    # add transmitter to the charges
    acc = case Enum.count(acc.charges) do
        5 ->
            [_|t] = acc.charges
            Map.put(acc, :charges, t)
        _ -> acc
    end
    Map.put(acc, :charges, acc.charges ++ [transmitter])
  end

  def calculate_charge(charges, now) do
    Enum.reduce(charges, 0, fn(el, sum) ->
      {t, ts} = el
      diff = :timer.now_diff(now, ts)
      # IO.puts "calc with #{diff}"
      val = cond do
        diff < 10 -> t
        diff < 20 -> t / 2
        diff < 30 -> t / 4
        :true -> 0
      end

      charge = Enum.max([Enum.min([sum + val, 10]), -10])
    end)
  end
end
