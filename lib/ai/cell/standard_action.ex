defmodule AI.Cell.StandardAction do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces positive charges/trasmitters
  """

  @behaviour AI.Cell

  def impulse(subscriber, charge) do
    AI.Cell.stimulate(subscriber, charge)
  end
end
