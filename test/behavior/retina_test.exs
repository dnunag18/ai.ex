defmodule AI.Behavior.RetinaTest do
  use ExUnit.Case

  setup do
    ["3-2", "4-2", "5-2", "5-3", "4-3", "3-3", "3-4", "4-4", "5-4"]
    {:ok, retina} = AI.Nucleus.Retina.create
    for i <- 0..(Enum.count(retina.outputs) - 1) do
      row = retina.outputs |> Enum.at(i)
      for j <- 0..(Enum.count(row) - 1) do
        ganglion = row |> Enum.at(j)
        {logger, _} = AI.Cell.Debug.Logger.start_link(%AI.Cell.Debug.Logger{name: "g#{i}_#{j}"})
        GenEvent.call(ganglion, AI.Cell, {:add_subscriber, logger})
      end
    end
    {:ok, retina: retina}
  end

  test "tests a friggin square", %{retina: retina} do
    coords = [{3,2}, {4,2}, {5,2}, {5,3}, {4,3}, {3,3}, {3,4}, {4,4}, {5,4}]
    charge = 5
    :timer.sleep(100)
    IO.puts "start on-2 off #{inspect :os.timestamp}"
    Enum.each(1..30, fn(_) ->
      :timer.sleep(10)
      now = :os.timestamp
      Enum.each(coords, fn({x, y}) ->
        Enum.each(
          retina.inputs |> Enum.at(y) |> Enum.at(x),
          &GenEvent.notify(&1, {:stimulate, {charge, now}})
        )
      end)
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    :timer.sleep(1000)
  end
end
