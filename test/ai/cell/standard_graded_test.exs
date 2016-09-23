defmodule AI.Cell.StandardGradedTest do
  use ExUnit.Case
  
  @moduletag :capture_log

  alias AI.Cell

  setup do
    Application.stop(:ai)
    :ok = Application.start(:ai)
  end

  setup do
    {:ok, cell} = AI.Cell.StandardGraded.start_link
    {:ok, cell: cell}
  end

  test "should be able to create an instance" do
    {:ok, cell} = AI.Cell.StandardGraded.start_link
    assert cell != nil
  end

  test "should be able to add subscribers", %{cell: cell} do
    {:ok, subscribers} = Cell.subscribe(cell, cell)
    assert Enum.any?(subscribers, fn(s) -> s == cell end)
  end

  test "should be able to stimulate the cell", %{cell: cell} do
    {:ok, charge, _} = Cell.stimulate(cell, 10)
    assert charge == 10
  end

  test "should start decaying if no charge", %{cell: cell} do
    {:ok, _, pid} = Cell.stimulate(cell, 3)
    assert pid != nil
  end

  test "should not start a new decay chain if one already exists", %{cell: cell} do
    {:ok, _, pid1} = Cell.stimulate(cell, 3)
    assert pid1 != nil
    {:ok, _, pid2} = Cell.stimulate(cell, 3)
    assert pid2 == nil
  end

end
