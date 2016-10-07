defmodule AI.Cell.StandardGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent

  defstruct [
    subscribers: [],
    threshold: 0.0,
    name: "-"
  ]

  def handle_event({:stimulate, transmitter}, state) do
    # IO.puts "#{inspect state.name} - #{transmitter}"
    {:ok, state}
  end

  def handle_call(:subscribers, state) do
    {:ok, state.subscribers, state}
  end

  def handle_call({:add_subscriber, subscriber}, state) do
    state = Map.put(state, :subscribers, [subscriber|state.subscribers])
    {:ok, state.subscribers, state}
  end

  def handle_call({:name, name}, state) do
    {:ok, name, Map.put(state, :name, name)}
  end

  def start_link(name) do
    state = %__MODULE__{}
    {:ok, pid} = GenEvent.start_link
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    GenEvent.call(pid, __MODULE__, {:name, name})
    task = start_processor(pid)

    {pid, task}
  end

  defp start_processor(pid) do
    {:ok, task} = Task.start_link(fn ->
      GenEvent.stream(pid)
      |> Stream.transform(%{charges: []}, fn({:stimulate, transmitter}, acc) ->
        now = :os.timestamp
        acc = accumulate_charges(transmitter, acc, now)

        charge = calculate_charge(acc.charges, now)

        {[charge], acc}
      end)
      |> Enum.each(&relay(&1, pid))
    end)
    task
  end

  defp accumulate_charges(transmitter, acc, now) do
    # add transmitter to the charges
    acc = case Enum.count(acc.charges) do
        5 ->
            [_|t] = acc.charges
            Map.put(acc, :charges, t)
        _ -> acc
    end
    Map.put(acc, :charges, acc.charges ++ [{transmitter, now}])
  end

  defp calculate_charge(charges, now) do
    Enum.reduce(charges, 0, fn(el, sum) ->
      {t, ts} = el
      diff = :timer.now_diff(now, ts)
      val = cond do
        diff < 10 -> t
        diff < 20 -> t / 2
        diff < 30 -> t / 4
        :true -> 0
      end
      Enum.max([Enum.min([sum + val, 10]), -10])
    end)
  end

  defp relay(charge, pid) do
    subscribers = GenEvent.call(pid, __MODULE__, :subscribers)
    num_subscribers = Enum.count(subscribers)
    charge = Float.floor(charge / num_subscribers)
    if charge != 0 do
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, charge}))
    end
  end
end
