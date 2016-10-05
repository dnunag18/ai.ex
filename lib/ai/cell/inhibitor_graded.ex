defmodule AI.Cell.InhibitorGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent

  defstruct [
    subscribers: [],
    threshold: 0.0
  ]

  def handle_event({:stimulate, transmitter}, state) do
    {:ok, state}
  end

  def handle_call(:subscribers, state) do
    {:ok, state.subscribers, state}
  end

  def handle_call({:add_subscriber, subscriber}, state) do
    state = Map.put(state, :subscribers, [subscriber|state.subscribers])
    {:ok, state.subscribers, state}
  end

  def start_link do
    state = %__MODULE__{}
    {:ok, pid} = GenEvent.start_link
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
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
        diff < 100 -> t
        diff < 200 -> t / 2
        diff < 300 -> t / 4
        :true -> 0
      end
      sum + val
    end)
  end
  
  defp relay(charge, pid) do
    if charge > 0 do
      subscribers = GenEvent.call(pid, __MODULE__, :subscribers)
      num_subscribers = Enum.count(subscribers)
      Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, -charge / num_subscribers}))
    end
  end
end
