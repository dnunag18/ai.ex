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

  test "should publish to subscribers after it is stimulated", %{cell: cell} do
    {:ok, subscriber} = AI.Cell.StandardGraded.start_link
    assert Cell.get(subscriber, :input_charge) == 0.0
    Cell.subscribe(cell, subscriber)
    {:ok, accept_task} = Cell.stimulate(cell, 10)
    Task.await(accept_task)
    assert Cell.get(subscriber, :input_charge) > 0.0
  end

end
