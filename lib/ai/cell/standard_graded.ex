defmodule AI.Cell.StandardGraded do
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

    {:ok, task} = Task.start_link(fn ->
      GenEvent.stream(pid)
      |> Stream.transform(%{charges: []}, fn({:stimulate, transmitter}, acc) ->
        IO.puts "#{inspect pid} transmitttter: #{inspect transmitter}"
        now = :os.timestamp
        # add transmitter to the charges
        acc = case Enum.count(acc.charges) do
            5 ->
                [_|t] = acc.charges
                Map.put(acc, :charges, t)
            _ -> acc
        end
        acc = Map.put(acc, :charges, acc.charges ++ [{transmitter, now}])

        # calculate current charge
        charge = Enum.reduce(acc.charges, 0, fn(el, sum) ->
          {t, ts} = el
          diff = :timer.now_diff(now, ts)
          val = cond do
            diff < 100 -> t
            diff < 500 -> t / 2
            diff < 1000 -> t / 4
            :true -> 0
          end
          sum + val
        end)

        {[charge], acc}
      end)

      # timeout 1 milli, send a zero (decay)
      # this will make the gradient continue to send out charges in
      # a gradual decline instead of a hard stop

      # relay transmitterssss
      |> Enum.each(fn(charge) ->
        if charge > 0 do
          subscribers = GenEvent.call(pid, __MODULE__, :subscribers)
          num_subscribers = Enum.count(subscribers)
          Enum.each(subscribers, &GenEvent.notify(&1, {:stimulate, charge / num_subscribers}))
        end
      end)
    end)

    {pid, task}
  end
end
