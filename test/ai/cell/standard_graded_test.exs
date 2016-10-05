defmodule AI.Cell.StandardGradedTest do
  use ExUnit.Case

  setup do
    cell = AI.Cell.StandardGraded.start_link
    {:ok, cell: cell}
  end

  test "should add a subscriber", %{cell: cell} do
    subscriber = AI.Cell.StandardGraded.start_link
    subscribers = GenEvent.call(cell, AI.Cell.StandardGraded, {:add_subscriber, subscriber})
    assert Enum.count(subscribers) == 1
    assert Enum.at(subscribers, 0) == subscriber
    GenEvent.stop(cell)
  end

end
