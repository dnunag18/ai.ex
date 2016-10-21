defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create



    {:ok, counter} = AI.Cell.start(%{
      module: AI.Cell.Count,
      threshold: :infinity,
      timeout: :infinity
    })
    # IO.puts("charge #{charge}")
    {:ok, circuit: circuit, counter: counter}
  end

  test "on center, off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("0-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end
  #
  test "on center, 1 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("1-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  test "on center, 2 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("2-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  test "on center, 3 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("3-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  test "on center, 4 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("4-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  test "on center, 5 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("5-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  test "on center, 6 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("6-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end


  test "on center, on surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(10)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      Enum.each(circuit.inputs, fn(row) ->
        Enum.each(row, &AI.Cell.stimulate(&1, charge))
      end)
    end)
    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    IO.puts("8-off ganglions: #{length(state.charges)}")
    print_charge(state)
  end

  def charge do
    20
  end

  def print_charge(state) do
    charges = Map.get(state, :charges, [])
    avg_charge = Enum.sum(charges) / Enum.max([1, Enum.count(charges)])
    IO.puts("charge: #{avg_charge}")
    IO.puts("--------------")
  end


end
