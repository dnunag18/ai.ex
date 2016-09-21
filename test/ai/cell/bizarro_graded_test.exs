defmodule AI.Cell.BizarroGradedTest do
  use ExUnit.Case, async: true

  @moduletag :capture_log

  alias AI.Cell.BizarroGraded

  setup do
    Application.stop(:ai)
    :ok = Application.start(:ai)
  end

  setup do
    {:ok, cell} = BizarroGraded.start_link
    {:ok, cell: cell}
  end

  test "should be able to create an instance" do
    {:ok, cell} = BizarroGraded.start_link
    assert cell != nil
  end

  test "should be able to add subscribers", %{cell: cell} do
    {:ok, subscribers} = BizarroGraded.subscribe(cell, cell)
    assert Enum.any?(subscribers, fn(s) -> s == cell end)
  end

  test "should be able to stimulate the cell", %{cell: cell} do
    {:ok, charge} = BizarroGraded.stimulate(cell, 10)
    assert charge == 10
  end

  test "charge should decay over time", %{cell: cell} do
    {:ok, _} = BizarroGraded.stimulate(cell, 10)
    assert BizarroGraded.get(cell, :charge) == 10
    Process.sleep(100)
    assert BizarroGraded.get(cell, :charge) == 0
  end
end
