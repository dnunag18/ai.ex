defmodule AI.Behavior.CenterSurroundTest do
  use ExUnit.Case

  setup do
    {:ok, circuit} = AI.Circuit.CenterSurround.create
    {:ok, circuit: circuit}
  end



end
