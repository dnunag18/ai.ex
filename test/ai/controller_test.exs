defmodule AI.ControllerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, cell} = AI.Controller.create(%AI.Cell.StandardGraded{})
    {:ok, cell: cell}
  end

  test "creates a cell" do
    {:ok, cell} = AI.Controller.create(AI.Cell.StandardGraded)
    assert cell != nil
  end
end
