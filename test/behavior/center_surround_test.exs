defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  alias AI.Cell


  setup do
    Application.stop(:ai)
    :ok = Application.start(:ai)
  end

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create
    {:ok, circuit: circuit}
  end

  test "on center, off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {:ok, logger_cell} = AI.Cell.Debug.Logger.start_link
    Cell.subscribe(ganglion, logger_cell)

    # test 10 inputs per second for 3 seconds
    Enum.each(1..30, fn(_) ->
      Process.sleep(100)
      Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), 20)
    end)

    Process.sleep(4000)
    IO.inspect ganglion
    IO.inspect logger_cell

  end

  test "on center and surround - fewer, equally spaced impulses", %{circuit: circuit} do

  end

  test "on surround, off center - basically no impulses", %{circuit: circuit} do

  end
end
