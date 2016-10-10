defmodule AI.Cell.Debug.Logger do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """
  use GenEvent

  defstruct [
    subscribers: [],
    threshold: 0.0,
    name: ""
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

  def start_link(state \\ %__MODULE__{}) do
    {:ok, pid} = GenEvent.start
    :ok = GenEvent.add_handler(pid, __MODULE__, state)
    task = start_processor(pid, state.name)

    {pid, task}
  end

  defp start_processor(pid, name) do
    {:ok, task} = Task.start_link(fn ->
      stream = Stream.with_index(GenEvent.stream(pid))

      for {el, i} <- stream do
        IO.puts "{#{name}, \"#{inspect el}\"}"
      end
    end)
    task
  end
end
