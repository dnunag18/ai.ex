defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create
    # IO.puts("charge #{charge}")
    {:ok, circuit: circuit}
  end

  test "on center, off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("0-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 1 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("1-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 2 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("2-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 3 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(2), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("3-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 4 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(0), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("4-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 5 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(1), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("5-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  test "on center, 6 off surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      GenEvent.notify(circuit.inputs |> Enum.at(0) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(1), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(1) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(2), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(0), {:stimulate, charge})
      GenEvent.notify(circuit.inputs |> Enum.at(2) |> Enum.at(1), {:stimulate, charge})
    end)

    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("6-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end


  test "on center, on surround - constant impulses", %{circuit: circuit} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    counter = AI.Cell.Count.start
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(10)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      Enum.each(circuit.inputs, fn(row) ->
        Enum.each(row, &GenEvent.notify(&1, {:stimulate, charge}))
      end)
    end)
    :timer.sleep(1100)
    state = GenEvent.call(counter, AI.Cell.Count, :state)
    IO.puts("8-off ganglions: #{Map.get(state, :hits, 0)}")
    print_charge(state)
  end

  def charge do
    10
  end

  def print_charge(state) do
    charges = Map.get(state, :total_charge, [])
    avg_charge = Enum.sum(charges) / Enum.max([1, Enum.count(charges)])
    IO.puts("charge: #{avg_charge}")
    IO.puts("--------------")
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
