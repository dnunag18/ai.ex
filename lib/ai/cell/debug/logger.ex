defmodule AI.Cell.Debug.Logger do
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
      stream = Stream.with_index(GenEvent.stream(pid))

      for {el, i} <- stream do
        IO.puts "#{i} #{inspect :os.timestamp} #{inspect el}"
      end
    end)
    task
  end
end
