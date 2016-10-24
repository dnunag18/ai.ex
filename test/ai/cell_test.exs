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
  test "should wait (timeout)ms after stimulus", %{cell: cell, counter: counter} do
    Cell.stimulate(cell, 10)
    state = Cell.get_state(counter)
    cell_state = Cell.get_state(cell)
    assert length(Map.get(state, :charges, 0)) == 0
    :timer.sleep(cell_state.timeout + 3)
    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 1
  end

  test "should wait (timeout)m after 1st stimulus", %{cell: cell, counter: counter} do
    Cell.stimulate(cell, 10)
    cell_state = Cell.get_state(cell)
    :timer.sleep(trunc(cell_state.timeout / 2))
    Cell.stimulate(cell, 10)

    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 0
    :timer.sleep(cell_state.timeout)
    state = Cell.get_state(counter)
    assert length(Map.get(state, :charges, 0)) == 1
  end

  test "should not accumulate after the cutoff time (timeout)", %{cell: cell, counter: counter} do
      Cell.stimulate(cell, 5)
      cell_state = Cell.get_state(cell)
      :timer.sleep(trunc(cell_state.timeout / 3))

      Cell.stimulate(cell, 6)
      :timer.sleep(trunc(cell_state.timeout / 3))
      cell_state = Cell.get_state(cell)

      assert length(Map.get(cell_state, :charges, 0)) == 2
      assert cell_state.charges == [6.0, 5.0]

      :timer.sleep(cell_state.timeout)
      cell_state = Cell.get_state(cell)

      assert length(Map.get(cell_state, :charges, 0)) == 0
      assert cell_state.charges == []
  end
end
