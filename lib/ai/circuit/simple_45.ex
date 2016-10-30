defmodule AI.Circuit.Simple45 do
  @moduledoc """
  Creates a simple diagonal 45 degree cell.  This cell is 4x1 pixels, but the
  input matrix is 4x4
  """
  defstruct [inputs: [[]], outputs: [[]]]

  def create(threshold \\ 10) do
    size = 4

    {:ok, pyramidal} = AI.Cell.start(%{
      name: "45_diagonal_pyramidal",
      threshold: threshold,
      module: AI.Cell.StandardAction
    })

    inputs = for i <- 1..size do
      for j <- 1..size do
        if i == j do
          pyramidal
        else
          nil
        end
      end
    end

    {
      :ok,
      %AI.Circuit.Simple45{
        inputs: inputs,
        outputs: [[pyramidal]]
      }
    }
  end
end
