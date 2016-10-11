defmodule Genetic.TuneRetinaTest do
  use ExUnit.Case

  test "do some genetic tuning dude", %{retina: retina} do

  end

  def generate_config do
    %{
      charge: :rand.uniform(30),
      ganglion: :rand.uniform(50),
      cone: :rand.uniform(3) - 1,
      in_to_out: :rand.uniform(30),
      out_to_in: :rand.uniform(30),
      bipolar: :rand.uniform(30)
    }
  end

  def repro(a, b) do
    Enum.reduce(fields, %{}, fn(field, child) ->
      parent = if :rand.uniform(2) == 1, do: a, else: b
      Map.put(child, field, Map.get(parent, field))
    end)
  end

  def mutate(a) do
    field = Enum.random(fields)
    if :rand.uniform(5) < 5 do
      Map.put(a, field, Map.get(generate_config, field))
    else
      a
    end
  end

  def gen_population(size, a \\ nil, b \\ nil) do
    Enum.map(1..size, fn() ->
      if a == nil do
        generate_config
      else
        repro(a, b) |> mutate()
      end
    end)
  end

  # score on a scale of 1 - 100?
  def score(results) do
    points = 0
    # if fill rate > 0, 2 points
    if results.fill_rate > 0 do
      points = points + 2
    end
    # if line rate > 0, 2 points
    if results.line_rate > 0 do
      points = points + 2
    end
    # if line rate > fill rate, 1 point
    if results.line_rate > results.fill_rate do
      points = points + 1
    end
    # if line rate >= 2x fill rate and both non zero, 10 points
    if results.line_rate >= 2 * results.fill_rate && results.fill_rate > 0 && results.line_rate > 0 do
      points = points + 10
    end
    # if line rate == fill rate, -1 points
    if results.line_rate == results.fill_rate do
      points = points - 1
    end
    points
  end

  def fields do
    [:charge, :ganglion, :cone, :in_to_out, :out_to_in, :bipolar]
  end
end
