defmodule AI.Circuit.CenterSurround do
  # return an object that can be manipulated by AI.Circuit.

  alias AI.Cell

  defstruct [inputs: [[]], outputs: [[]]]

  def create(thresholds \\ %{ganglion: 1, out_to_in: 9}) do
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
      threshold: Map.get(thresholds, :in_to_out, 0),
      module: Cell.InhibitorGraded
    })
    {:ok, out_to_in} = Cell.start(%{
      name: "out_to_in",
      threshold: Map.get(thresholds, :out_to_in, 9),
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
    GenEvent.call(bipolar, Cell, {:add_subscriber, ganglion})

    for i <- 0..2 do
      for j <- 0..2 do
        cone = at(cones, i, j)
        case {i, j} do
          {1, 1} ->
            GenEvent.call(cone, Cell, {:add_subscriber, in_to_out})
            GenEvent.call(out_to_in, Cell, {:add_subscriber, cone})
            GenEvent.call(cone, Cell, {:add_subscriber, bipolar})
          {_, _} ->
            GenEvent.call(cone, Cell, {:add_subscriber, out_to_in})
            GenEvent.call(in_to_out, Cell, {:add_subscriber, cone})
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
