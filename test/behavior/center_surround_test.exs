defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case, async: true

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
    assert length(state.charges) > 45
    print_charge(state, "0 Off")
  end

  test "1 off surround", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) > 43
    print_charge(state, "1 off")
  end

  test "2 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) > 45
    print_charge(state, "2 off")
  end

  test "3 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) > 20
    print_charge(state, "3 off")
  end

  test "4 off surround - constant impulses", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..50, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(1), charge)
    end)

    :timer.sleep(1100)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) < 30
    print_charge(state, "4 off")
  end

  test "on center, 5 off surround", %{circuit: circuit, counter: counter} do
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
    assert length(state.charges) < 10
    print_charge(state, "5 off")
  end

  test "on center, 6 off surround", %{circuit: circuit, counter: counter} do
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
    assert length(state.charges) < 10
    print_charge(state, "6 off")
  end


  test "on center, on surround", %{circuit: circuit, counter: counter} do
    ganglion = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(ganglion, counter)
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
    assert length(state.charges) < 6
    print_charge(state, "8 off")
  end

  def charge do
    20
  end

  def print_charge(state, name) do
    charges = Map.get(state, :charges, [])
    IO.puts("#{name}: #{Enum.count(charges)}")
    IO.puts("--------------")
  end

end
