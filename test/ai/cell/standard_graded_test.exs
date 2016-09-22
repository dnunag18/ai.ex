defmodule AI.Cell.StandardGradedTest do
  use ExUnit.Case, async: true

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

end
