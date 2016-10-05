defmodule AI.Cell.StandardActionTest do
  use ExUnit.Case

  setup do
    {cell, _} = AI.Cell.StandardAction.start_link
    {:ok, cell: cell}
  end

  test "should add a subscriber", %{cell: cell} do
    subscriber = AI.Cell.StandardAction.start_link
    subscribers = GenEvent.call(cell, AI.Cell.StandardAction, {:add_subscriber, subscriber})
    assert Enum.count(subscribers) == 1
    assert Enum.at(subscribers, 0) == subscriber
    GenEvent.stop(cell)
  end

  test "should stimulate the subscriber", %{cell: cell} do
    {source, _} = AI.Cell.StandardGraded.start_link
    _ = GenEvent.call(source, AI.Cell.StandardGraded, {:add_subscriber, cell})
    :timer.sleep(1000)
    for _ <- 0..100 do
      :ok = GenEvent.notify(source, {:stimulate, 10})
    end

    :timer.sleep(1000)
  end

end
