defmodule AI.Circuit.Simple135Test do
  use ExUnit.Case, async: true

  setup do
    {:ok, circuit} = AI.Circuit.Simple135.create(20 * 2.5) # needs 4 total ons
    {:ok, counter} = AI.Cell.start(%{
      module: AI.Cell.Count,
      threshold: :infinity,
      timeout: :infinity
    })
    {:ok, circuit: circuit, counter: counter}
  end

  test "1 out of 4 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(3), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) < 2
    print_charge(state, "2 of 6")
  end

  test "2 out of 4 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(3), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) < 2
    print_charge(state, "2 of 6")
  end

  test "3 out of 4 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(3), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(1), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    assert length(state.charges) > 8
    print_charge(state, "3 of 6")
  end

  test "4 out of 4 impulses ", %{circuit: circuit, counter: counter} do
    pyramidal = circuit.outputs |> Enum.at(0) |> Enum.at(0)
    AI.Cell.subscribe(pyramidal, counter)
    # test 10 inputs per second for 3 seconds
    :timer.sleep(100)
    Enum.each(1..10, fn(_) ->
      :timer.sleep(20)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(0) |> Enum.at(3), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(1) |> Enum.at(2), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(2) |> Enum.at(1), charge)
      AI.Cell.stimulate(circuit.inputs |> Enum.at(3) |> Enum.at(0), charge)
    end)

    :timer.sleep(210)
    state = AI.Cell.get_state(counter)
    print_charge(state, "4 of 6")
    assert length(state.charges) > 8
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
