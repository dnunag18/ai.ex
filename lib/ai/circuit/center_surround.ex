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

  defstruct [input: [[]], output: [[]]]

  def create do
    # cells
    ganglion = Cell.StandardAction.start_link
    bipolar = Cell.StandardGraded.start_link

    in_to_out = Cell.BizarroGraded.start_link
    out_to_in = Cell.BizarroGraded.start_link

    cones = for i <- 0..2 do
      for j <- 0..2 do
        Cell.StandardGraded.start_link
      end
    end

    # connections
    Cell.subscribe(bipolar, ganglion)

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

    %AI.Circuit.CenterSurround{
      input: cones,
      output: [[ganglion]]
    }
  end

  defp at(list, i, j) do
    list |> Enum.at(i) |> Enum.at(j)
  end
end
