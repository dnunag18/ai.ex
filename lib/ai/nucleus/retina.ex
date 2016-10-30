defmodule AI.Nucleus.Retina do
  @moduledoc """
  Creates retina nucleus
  """
  alias AI.Circuit.CenterSurround

  defstruct [inputs: [[[]]], outputs: [[]], agent: nil]

  def create(thresholds \\ %{}) do
    size = 10

    # should probs be a supervisor
    {:ok, agent} = Agent.start(fn ->
      for _ <- 1..size do
        for _ <- 1..size do
          {:ok, circuit} = CenterSurround.create(thresholds)
          circuit
        end
      end
    end)

    cs_matrix = Agent.get(agent, fn state -> state end)

    inputs = Enum.reduce(cs_matrix, [], fn(row, stacks) ->
      AI.Nucleus.stack(
        stacks,
        Enum.reduce(row, [], fn(cs, fields) ->
          AI.Nucleus.bind(
            fields,
            AI.Nucleus.wrap_elems(cs.inputs),
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
        outputs: outputs,
        agent: agent
      }
    }
  end
end
