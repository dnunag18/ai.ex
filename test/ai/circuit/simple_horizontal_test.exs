defmodule AI.Circuit.SimpleHorizontalTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, circuit} = AI.Circuit.SimpleHorizontal.create(20 * 4 - 5) # needs 4 total ons
    {:ok, counter} = AI.Cell.start(%{
      module: AI.Cell.Count,
      threshold: :infinity,
      timeout: :infinity
    })
    {:ok, circuit: circuit, counter: counter}
  end

  test "2 out of 6 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) < 1
    print_charge(state, "2 of 6")
  end

  test "3 out of 6 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) < 3
    print_charge(state, "3 of 6")
  end

  test "4 out of 6 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(3) |> Enum.at(0), charge)
    end)

    :timer.sleep(2010)
    state = AI.Cell.get_state(counter)
    print_charge(state, "4 of 6")
    assert length(state.charges) == 10
  end

  test "5 out of 6 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(3) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(4) |> Enum.at(0), charge)
    end)

    :timer.sleep(2010)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) >= 9
    print_charge(state, "5 of 6")
  end

  test "6 out of 6 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(3) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(4) |> Enum.at(0), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(5) |> Enum.at(0), charge)
    end)

    :timer.sleep(2010)
    state = AI.Cell.get_state(counter)
    print_charge(state, "6 of 6")
    assert length(state.charges) >= 9
  end

  def print_charge(state, name) do
    charges = Map.get(state, :charges, [])
    IO.puts("#{name}: #{Enum.count(charges)}")
    IO.puts("--------------")
  end

  def charge do
    20
  end
end
