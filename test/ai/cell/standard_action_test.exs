defmodule AI.Cell.StandardActionTest do
  use ExUnit.Case
  import Task
  @moduletag :capture_log

  alias AI.Cell

  setup do
    Application.stop(:ai)
    :ok = Application.start(:ai)
  end

  setup do
    {:ok, cell} = AI.Cell.StandardAction.start_link
    {:ok, subscriber } = AI.Cell.StandardAction.start_link
    Cell.subscribe(cell, subscriber)
    {:ok, cell: cell, subscriber: subscriber}
  end

  test "should be able to create an instance" do
    {:ok, cell} = AI.Cell.StandardAction.start_link
    assert cell != nil
  end

  test "should be able to add subscribers", %{cell: cell} do
    {:ok, subscribers} = Cell.subscribe(cell, cell)
    assert Enum.any?(subscribers, fn(s) -> s == cell end)
  end

  test "should be able to stimulate the cell", %{cell: cell} do
    {:ok, charge, _, _} = Cell.stimulate(cell, 10)
    assert charge == 10
  end

  test "should not publish if charge is under threshold", %{cell: cell} do
    {:ok, charge, _, publish_task} = Cell.stimulate(cell, 5)
    {publish_status, _} = Task.await(publish_task)
    assert publish_status == :not_published
  end

  test "should publish if charge is >= threshold", %{cell: cell} do
    {:ok, charge, _, _} = Cell.stimulate(cell, 20)
  end
end
