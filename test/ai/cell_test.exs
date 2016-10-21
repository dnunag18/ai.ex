defmodule AI.CellTest do
  use ExUnit.Case

  @moduletag :capture_log

  alias AI.Cell


  setup do
    {:ok, cell} = AI.Cell.start(%{
      module: AI.Cell.StandardGraded
    })
    {:ok, counter} = AI.Cell.start(%{
      module: AI.Cell.Count,
      threshold: :infinity,
      timeout: :infinity
    })

    AI.Cell.subscribe(cell, counter)
    {:ok, cell: cell, counter: counter}
  end

# should not output more than 5 ms
# if stimulated, should wait 5 ms, or max before  impulse
  test "should wait 5ms after stimulus", %{cell: cell, counter: counter} do
    Cell.stimulate(cell, 10)
    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 0
    :timer.sleep(20)
    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 1
  end

  test "should wait 5m after 1st stimulus", %{cell: cell, counter: counter} do
    Cell.stimulate(cell, 10)
    :timer.sleep(3)
    Cell.stimulate(cell, 10)

    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 0
    :timer.sleep(7)
    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 1
  end

  test "should not accumulate after the cutoff time (5)", %{cell: cell, counter: counter} do
      Cell.stimulate(cell, 5)
      :timer.sleep(7)

      Cell.stimulate(cell, 6)
      :timer.sleep(7)

      state = Cell.get_state(counter)

      assert length(Map.get(state, :charges, 0)) == 2
      assert state.charges == [6.0, 5.0]
  end
end
