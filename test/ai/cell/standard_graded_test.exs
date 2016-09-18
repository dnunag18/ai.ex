defmodule AI.Cell.StandardGradedTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, cell} = AI.Controller.create(%AI.Cell.StandardGraded{})
    {:ok, cell: cell}
  end

  test "adds to subscriber list", %{cell: cell} do
    AI.Cell.connect(cell, cell)
    assert Enum.any?(cell.subscribers, fn(c) -> c == cell end)
  end
end
