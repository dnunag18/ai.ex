defmodule AI.Cell.StandardActionTest do
  use ExUnit.Case

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

  test "should publish to subscribers after it is stimulated and above the threshold", %{cell: cell, subscriber: subscriber} do
    assert Cell.get(subscriber, :input_charge) == 0.0
    {:ok, accept_task} = Cell.stimulate(cell, 40)
    Task.await(accept_task)
    charge = Cell.get(subscriber, :input_charge) + Cell.get(subscriber, :charge)
    assert charge > 0.0
  end

  test "should not publish to subscribers if charge is below threshold", %{cell: cell, subscriber: subscriber} do
    assert Cell.get(subscriber, :input_charge) == 0.0
    Cell.subscribe(cell, subscriber)
    {:ok, accept_task} = Cell.stimulate(cell, 3)
    Task.await(accept_task)
    assert Cell.get(subscriber, :input_charge) == 0.0
  end

end
