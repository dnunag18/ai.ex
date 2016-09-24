defmodule AI.CellTest do
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

  test "should start decaying if no charge", %{cell: cell} do
    {:ok, task} = Cell.stimulate(cell, 3)
    assert task != nil
  end

  test "should not start a new decay chain if one already exists", %{cell: cell} do
    {:ok, task1} = Cell.stimulate(cell, 3)
    assert task1 != nil
    {:ok, task2} = Cell.stimulate(cell, 3)
    assert task2 == nil
  end

  test "charge decays after input", %{cell: cell} do
    charge = 10
    {:ok, task} = Cell.stimulate(cell, charge)
    Task.await(task)
    assert Cell.get(cell, :charge) < charge
  end

end
