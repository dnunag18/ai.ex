defmodule AI.Circuit.SimpleHorizontal do
  @moduledoc """
  Creates a simple horizontal cell.  This cell is 6x1 pixels
  """
  defstruct [inputs: [[]], outputs: [[]]]

  def create(threshold \\ 10) do
    size = 6

    {:ok, pyramidal} = AI.Cell.start(%{
      name: "horizontal_pyramidal",
      threshold: threshold,
      module: AI.Cell.StandardAction
    })

    {
      :ok,
      %AI.Circuit.SimpleHorizontal{
        inputs: (for i <- 1..size, do: [pyramidal]),
        outputs: [[pyramidal]]
      }
    }
  end
end
