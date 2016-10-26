defmodule AI.Cell.Count do
  @moduledoc """
  This cell is meant to store all charges and to be used for testing/debugging.
  Normal setup would require setting `:threshold` and `:timeout` to `:infinity`
  """

  def impulse(state) do
    {:ok, nil, state}
  end

end
