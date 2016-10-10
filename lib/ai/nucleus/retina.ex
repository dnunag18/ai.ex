defmodule AI.Nucleus.Retina do
  alias AI.Circuit.CenterSurround

  defstruct [inputs: [[[]]], outputs: [[]]]

  def create do
    size = 10
    cs_size = 3

    cs_matrix = for _ <- 1..size do
      for _ <- 1..size do
        {:ok, circuit} = CenterSurround.create
        circuit
      end
    end

    inputs = Enum.reduce(cs_matrix, [], fn(row, stacks) ->
      stack(
        stacks,
        Enum.reduce(row, [], fn(cs, fields) ->
          bind(
            fields,
            wrap_elems(cs.inputs),
            2
          )
        end),
        2
      )
    end)
    outputs = Enum.map(cs_matrix, fn(row) ->
      Enum.map(row, fn(c) ->
        c.outputs |> Enum.at(0) |> Enum.at(0)
      end)
    end)

    {
      :ok,
      %__MODULE__{
        inputs: inputs,
        outputs: outputs
      }
    }
  end

  def bind(left, right, overlap \\ 0) do
    height = Enum.count(left)
    if height == 0 do
      right
    else
      left_width = Enum.count(Enum.at(left, 0))
      right_width = Enum.count(Enum.at(right, 0))
      stitch_width = left_width + right_width
      Enum.map(0..(height - 1), fn(i)->
        Enum.reduce(0..(stitch_width - 1), [], fn(j, acc) ->
          matrix = case j >= left_width do
            :true -> right
            :false -> left
          end

          el = matrix |> Enum.at(i) |> Enum.at(rem(j, left_width))

          if left_width <= j && j - left_width < overlap do
            [prev|tail] = Enum.take(acc, overlap - j - 1)
            Enum.take(acc, left_width - j + overlap - 1) ++ [prev ++ el | tail]
          else
            [el|acc]
          end
        end) |> Enum.reverse()
      end)
    end
  end

  def stack(top, bottom, overlap \\ 0) do
    top_height = Enum.count(top)
    if top_height == 0 do
      bottom
    else
      width = Enum.count(Enum.at(top, 0))
      bottom_height = Enum.count(bottom)
      stitch_height = top_height + bottom_height
      Enum.reduce(0..(stitch_height - 1), [], fn(i, acc) ->
        matrix = case i >= top_height do
          :true -> bottom
          :false -> top
        end

        row = matrix |> Enum.at(rem(i, top_height))

        if top_height <= i && i - top_height < overlap do
          [prev|tail] = Enum.take(acc, overlap - i - 1)
          Enum.take(acc, top_height - i + overlap - 1) ++ [
            Enum.map(
              Enum.zip(
                prev,
                row
              ),
              &Tuple.to_list(&1)
            ) |> Enum.map(fn([x, y]) -> x ++ y end)
            |tail
          ]
        else
          [row|acc]
        end
      end) |> Enum.reverse()
    end
  end

  def wrap_elems(matrix) do
    Enum.map(matrix, fn(row) ->
      Enum.map(row, &([&1]))
    end)
  end
end
