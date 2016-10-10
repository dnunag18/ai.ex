defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create
    {:ok, circuit: circuit}
  end

  test "on center, off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {logger, _} = AI.Cell.Debug.Logger.start_link
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, logger})
    charge = 5
    # test 10 inputs per second for 3 seconds
    Process.sleep(100)
    IO.puts "start on-off #{inspect :os.timestamp}"
    Enum.each(1..60, fn(_) ->
      Process.sleep(40)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, {charge, :os.timestamp}})
      # GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, {charge, :os.timestamp}})
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    Process.sleep(1000)
  end

  test "on center, 1 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {logger, _} = AI.Cell.Debug.Logger.start_link
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, logger})
    charge = 5
    # test 10 inputs per second for 3 seconds
    Process.sleep(100)
    IO.puts "start on-1 off #{inspect :os.timestamp}"
    Enum.each(1..60, fn(_) ->
      Process.sleep(40)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, {charge, :os.timestamp}})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, {charge, :os.timestamp}})
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    Process.sleep(1000)
  end


  test "on center, on surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    {logger, _} = AI.Cell.Debug.Logger.start_link
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, logger})
    charge = 5
    # test 10 inputs per second for 3 seconds
    Process.sleep(10)
    IO.puts "start on on #{inspect :os.timestamp}"
    Enum.each(1..30, fn(_) ->
      Process.sleep(50)
      Enum.each(circuit.inputs, fn(row) ->
        Enum.each(row, &GenEvent.notify(&1, {:stimulate, {charge, :os.timestamp}}))
      end)
    end)
    IO.puts "finish #{inspect :os.timestamp}"

    Process.sleep(1000)
  end

  # test "off center, on surround - constant impulses", %{circuit: circuit} do
  #   ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
  #   {logger, _} = AI.Cell.Debug.Logger.start_link
  #   GenEvent.call(ganglion, AI.Cell, {:add_subscriber, logger})
  #
  #   # test 10 inputs per second for 3 seconds
  #   :timer.sleep(10)
  #   IO.puts "start off on #{inspect :os.timestamp}"
  #   Enum.each(1..30, fn(_) ->
  #     for i <- 0..2 do
  #       for j <- 0..2 do
  #         cone = circuit.inputs |> Enum.at(i) |> Enum.at(j)
  #
  #         if i != 1 && j != 1 do
  #           GenEvent.notify(cone, {:stimulate, {10, :os.timestamp}})
  #         end
  #       end
  #     end
  #   end)
  #   IO.puts "finish #{inspect :os.timestamp}"
  #
  #   Process.sleep(1000)
  # end

end
