defmodule WebsocketHandler do
  @moduledoc """
  Websocket that accepts input for a retina, and returns the retina's output
  """
  @behaviour :cowboy_websocket

  def init(req, _) do
    {:ok, retina} = AI.Nucleus.Retina.create

    for i <- 0..(Enum.count(retina.outputs) - 1) do
      row = retina.outputs |> Enum.at(i)
      for j <- 0..(Enum.count(row) - 1) do
        ganglion = row |> Enum.at(j)
        {:ok, monitor} = AI.Cell.start(%{
          x: i,
          y: j,
          monitor: self,
          module: AI.Cell.Monitor
        })
        AI.Cell.subscribe(ganglion, monitor)
      end
    end
    {:cowboy_websocket, req, %{retina: retina}}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle({:text, charges}, req, %{retina: retina} = state) do
    Task.start(fn ->
      charges = :jiffy.decode(charges)
      Enum.each(charges, fn([x, y, charge]) ->
        cones = retina.inputs |> Enum.at(y) |> Enum.at(x)
        Enum.each(cones, &AI.Cell.stimulate(&1, charge))
      end)
    end)
    {:ok, req, state}
  end

  # fallback message handler
  def websocket_info({x, y, charge}, req, state) do
    encoded = :jiffy.encode([x, y, charge])
    {:reply, {:text, encoded}, req, state}
  end
end
