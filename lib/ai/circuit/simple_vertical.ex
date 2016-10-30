defmodule AI.Circuit.SimpleVertical do
  @moduledoc """
  Creates a simple horizontal cell.  This cell is 6x1 pixels
  """
  defstruct [inputs: [[]], outputs: [[]]]

  def create(threshold \\ 10) do
    size = 6

    {:ok, pyramidal} = AI.Cell.start(%{
      name: "vertical_pyramidal",
      threshold: threshold,
      module: AI.Cell.StandardAction
    })

    {
      :ok,
      %AI.Circuit.SimpleVertical{
        inputs: (for i <- 1..size, do: [pyramidal]),
        outputs: [[pyramidal]]
      }
    }
  end
end
