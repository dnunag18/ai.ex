defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create
    {:ok, circuit: circuit}
  end

  test "on center, off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {logger, _} = AI.Cell.Debug.Logger.start_link
    GenEvent.call(ganglion, AI.Cell.StandardAction, {:add_subscriber, logger})

    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    IO.puts "start on-off #{inspect :os.timestamp}"
    Enum.each(1..30, fn(_) ->
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, 10})
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    Process.sleep(500)

  end


  test "on center, on surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {logger, _} = AI.Cell.Debug.Logger.start_link
    GenEvent.call(ganglion, AI.Cell.StandardAction, {:add_subscriber, logger})

    # test 10 inputs per second for 3 seconds
    :timer.sleep(10)
    IO.puts "start on on #{inspect :os.timestamp}"
    Enum.each(1..30, fn(_) ->
      Enum.each(circuit.inputs, fn(row) ->
        Enum.each(row, &GenEvent.notify(&1, {:stimulate, 10}))
      end)
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    Process.sleep(500)

  end

end
