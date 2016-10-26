defmodule AI.Circuit.CenterSurround do
  @moduledoc """
  Creates a center surround circuit
  """
  alias AI.Cell

  defstruct [inputs: [[]], outputs: [[]]]

  def create(thresholds \\ %{}) do
    # cells
    {:ok, ganglion} = Cell.start(%{
      name: "ganglion",
      threshold: Map.get(thresholds, :ganglion, 1),
      module: Cell.StandardAction
    })
    {:ok, bipolar} = Cell.start(%{
      name: "bipolar",
      threshold: Map.get(thresholds, :bipolar, 0),
      module: Cell.StandardGraded
    })
    {:ok, in_to_out} = Cell.start(%{
      name: "in_to_out",
      threshold: Map.get(thresholds, :out_to_in, 0),
      module: Cell.InhibitorGraded
    })
    {:ok, out_to_in} = Cell.start(%{
      name: "out_to_in",
      threshold: Map.get(thresholds, :out_to_in, 0),
      module: Cell.InhibitorGraded
    })

    cones = for i <- 0..2 do
      for j <- 0..2 do
        name = "cone_#{i}_#{j}"
        {:ok, cone} = Cell.start(%{
          name: name,
          threshold: Map.get(thresholds, :cone, 0),
          module: Cell.StandardGraded
        })
        cone
      end
    end

    # connections
    Cell.subscribe(bipolar, ganglion)
    Cell.subscribe(out_to_in, bipolar)

    for i <- 0..2 do
      for j <- 0..2 do
        cone = at(cones, i, j)
        case {i, j} do
          {1, 1} ->
            Cell.subscribe(cone, in_to_out)
            Cell.subscribe(out_to_in, cone)
            Cell.subscribe(cone, bipolar)
          {_, _} ->
            Cell.subscribe(cone, out_to_in)
            Cell.subscribe(in_to_out, cone)
        end
      end
    end

    {
      :ok,
      %AI.Circuit.CenterSurround{
        inputs: cones,
        outputs: [[ganglion]]
      }
    }
  end

  defp at(list, i, j) do
    list |> Enum.at(i) |> Enum.at(j)
  end
end
