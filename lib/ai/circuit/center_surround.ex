defmodule AI.Circuit.CenterSurround do
  # return an object that can be manipulated by AI.Circuit.
  # shape:
  # level 1
  # C1 C2 C3
  # C4 C5 C6
  # C7 C8 C9
  #
  # level 2
  # H1 H2 B
  #
  # level 3
  # G
  #
  # connections:
  # C1 -> H1
  # C2 -> H1
  # C3 -> H1
  # C4 -> H1
  # C6 -> H1
  # C7 -> H1
  # C8 -> H1
  # C9 -> H1
  #
  # C5 -> H2
  #
  # H1 -> C5
  #
  # H2 -> C1
  # H2 -> C2
  # H2 -> C3
  # H2 -> C4
  # H2 -> C6
  # H2 -> C7
  # H2 -> C8
  # H2 -> C9
  #
  # C5 -> B
  #
  # B -> G

  alias AI.Cell

  defstruct [inputs: [[]], outputs: [[]]]

  def create do
    # cells
    {:ok, ganglion} = Cell.start(%{name: "ganglion", threshold: 1, module: Cell.StandardAction})
    {:ok, bipolar} = Cell.start(%{name: "bipolar", module: Cell.StandardGraded})

    {:ok, in_to_out} = Cell.start(%{name: "in_to_out", module: Cell.InhibitorGraded})
    {:ok, out_to_in} = Cell.start(%{name: "out_to_in", module: Cell.InhibitorGraded})

    cones = for i <- 0..2 do
      for j <- 0..2 do
        {:ok, cone} = Cell.start(%{name: "cone #{i}-#{j}", module: Cell.StandardGraded})
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
