defmodule TuneRetina do
  @behaviour Application

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

  def start(_, _) do
    run()
    :ok
  end

  def run(winners \\ nil, generation \\ 0) do
    IO.puts("starting generation #{generation}")
    if generation < 1000 do
      winners = gen_population(winners)
      |> Enum.map(&test(&1))
      |> Enum.map(&score(&1))
      |> select() # Returns 2 winners of the population
      |> run(generation + 1)
    else
      IO.puts("#{inspect winners}")
    end
  end

  def test(config) do
    IO.puts("testing: #{inspect config}")
    {:ok, retina} = AI.Nucleus.Retina.create(config)
    counters = for i <- 0..(Enum.count(retina.outputs) - 1) do
      row = retina.outputs |> Enum.at(i)
      for j <- 0..(Enum.count(row) - 1) do
        ganglion = row |> Enum.at(j)
        name = cond do
          (i == 0 || i == 2) && (j == 0 || j == 2) -> "corner"
          (i == 1 && j == 1) -> "fill"
          :true -> "line"
        end
        counter = AI.Cell.Count.start(%{name: name})
        GenEvent.call(ganglion, AI.Cell, {:add_subscriber, counter})
        counter
      end
    end |> Enum.reduce([], fn(row, acc) -> acc ++ row end)
    show_a_square(retina, config.charge)
    AI.Nucleus.Retina.stop(retina)
    {config, counters}
  end

  def show_a_square(retina, charge) do
    coords = [{3,2}, {4,2}, {5,2}, {5,3}, {4,3}, {3,3}, {3,4}, {4,4}, {5,4}]
    :timer.sleep(10)
    Enum.each(1..25, fn(_) ->
      :timer.sleep(20)
      now = :os.timestamp
      Enum.each(coords, fn({x, y}) ->
        Enum.each(
          retina.inputs |> Enum.at(y) |> Enum.at(x),
          &GenEvent.notify(&1, {:stimulate, {charge, now}})
        )
      end)
    end)
    :timer.sleep(500)
  end

  def repro([a, b]) do
    Enum.reduce(fields, %{}, fn(field, child) ->
      parent = if :rand.uniform(2) == 1, do: a, else: b
      child = Map.put(child, field, Map.get(parent, field))
      if :rand.uniform(2) == 1, do: child, else: generate_config
    end)
  end

  def mutate(a) do
    field = Enum.random(fields)
    Map.put(a, field, Map.get(generate_config, field))
  end

  def gen_population(parents \\ nil, size \\ 25) do
    Enum.map(1..size, fn(_) ->
      if parents == nil do
        generate_config
      else
        repro(parents) |> mutate()
      end
    end)
  end

  def select(population) do
    winners = Enum.take(population, 2)
    IO.puts("winners: #{inspect winners}")
    Enum.reduce(population, winners, fn(i, winners) ->
      winners = winners ++ [i]
      [_loser|winners] = Enum.sort(winners, fn({_, a_score}, {_, b_score}) ->
        a_score < b_score
      end)
      winners
    end) |> Enum.map(fn({config, score}) ->
      IO.puts("score: #{score}, config: #{inspect config}")
      config
    end)
  end

  def calculate_rates(counters) do
    results = counters |> Enum.reduce(%{}, fn(counter, results) ->
      state = GenEvent.call(counter, AI.Cell.Count, :state)
      hits = case state.name do
        "fill" -> Map.get(results, :fill, []) ++ [Map.get(state, :hits, 0)]
        "line" -> Map.get(results, :line, []) ++ [Map.get(state, :hits, 0)]
        "corner" -> Map.get(results, :corner, []) ++ [Map.get(state, :hits, 0)]
      end
      Map.put(results, String.to_atom(state.name), hits)
    end)
    Enum.reduce([:fill, :line, :corner], %{}, fn(field, acc) ->
      hits = Map.get(results, field, [0])
      Map.put(acc, field,  Enum.sum(hits) / Enum.count(hits))
    end)
  end

  # score on a scale of 1 - 100?
  def score({config, counters}) do
    %{
      fill: fill_rate,
      line: line_rate,
      corner: corner_rate
    } = calculate_rates(counters)

    points = 0

    # if fill rate > 0, 2 points
    points = if fill_rate > 0, do: points + 2, else: points

    # if line rate > 0, 2 points
    points = if line_rate > 0, do: points + 2, else: points

    points = if corner_rate > 0, do: points + 2, else: points

    points = if corner_rate < 100, do: points + 2, else: points

    points = if line_rate < 100, do: points + 2, else: points

    points = if fill_rate < 100, do: points + 2, else: points

    points = if config.charge < 10, do: points + 3, else: points

    points = if config.cone == 0, do: points + 3, else: points

    points = if config.bipolar == 0, do: points + 2, else: points

    # if line rate > fill rate, 1 point
    points = if line_rate > fill_rate, do: points + 1, else: points

    points = if corner_rate > fill_rate, do: points + 1, else: points

    is_non_zeros = fill_rate > 0 && line_rate > 0 && corner_rate > 0
    points = if is_non_zeros && line_rate >= 2 * fill_rate, do: points + 10, else: points
    points = if is_non_zeros && abs(corner_rate - line_rate) < 10, do: points + 10, else: points

    # if line rate == fill rate, -1 points
    points = if line_rate == fill_rate, do: points + -1, else: points

    {config, points}
  end

  def fields do
    [:charge, :ganglion, :cone, :in_to_out, :out_to_in, :bipolar]
  end
end
