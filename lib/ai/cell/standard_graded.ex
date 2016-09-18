defmodule AI.Cell.StandardGraded do
  @behaviour AI.Cell

  defstruct [subscribers: [], charge: 0]

  def start_link do
    Agent.start_link(fn -> %AI.Cell.StandardGraded{} end)
  end

  def stimulate(cell, transmitter) do
    charge = get(cell, :charge) + transmitter
    put(cell, :charge, charge)
    {:ok, charge}
  end

  def subscribe(publisher, subscriber) do
    subscribers = get(publisher, :subscribers) ++ [subscriber]
    {put(publisher, :subscribers, subscribers), subscribers}
  end

  defp get(cell, key) do
    Agent.get(cell, &Map.get(&1, key))
  end

  defp put(cell, key, value) do
    Agent.update(cell, &Map.put(&1, key, value))
  end
end
