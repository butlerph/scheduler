defmodule Genetic do
  alias Types.Chromosome
  alias Toolbox.Repair

  @doc """
  Runs the genetic algorithm given data and a problem.
  """
  def run(problem, data, opts \\ []) when is_map(data) and is_list(opts) do
    fn -> problem.genotype(data) end
    |> initialize()
    |> evolve(0, 0, 0, problem, data, opts)
  end

  defp initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  defp evolve(population, generation, last_max_fitness, temperature, problem, data, opts) do
    cool_rate = Keyword.get(opts, :cool_rate, 0.2)
    population = evaluate(population, &problem.fitness_function/2, data, opts)
    best = hd(population)

    # gen_str = Integer.to_string(generation)
    # fitness_str = Float.to_string(best.fitness)
    # str = IO.iodata_to_binary(["\r[", gen_str, " Current best ", fitness_str])

    # IO.write(str)

    temperature = (1 - cool_rate) * (temperature + (best.fitness - last_max_fitness))

    if problem.terminate?(population, generation, temperature) do
      best
    else
      {parents, leftover} = select(population, opts)
      children = crossover(parents, data, opts)

      reinsertion(parents, children, leftover, opts)
      |> mutation(data, opts)
      |> evolve(generation + 1, best.fitness, temperature, problem, data, opts)
    end
  end

  defp select(population, opts) do
    select_fn = Keyword.get(opts, :selection_type, &Toolbox.Selection.natural/3)
    select_rate = Keyword.get(opts, :selection_rate, 0.8)

    n = round(length(population) * select_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    parents = apply(select_fn, [population, n, opts])

    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))

    {parents, MapSet.to_list(leftover)}
  end

  defp reinsertion(parents, offspring, leftover, opts) do
    reinsert_fn = Keyword.get(opts, :reinsertion_type, &Toolbox.Reinsertion.pure/4)
    apply(reinsert_fn, [parents, offspring, leftover, opts])
  end

  defp evaluate(population, fitness_function, data, _opts) do
    population
    |> Enum.map(fn c ->
      fitness = fitness_function.(c, data)
      %Chromosome{c | fitness: fitness, age: c.age + 1}
    end)
    |> Enum.sort_by(&fitness_function.(&1, data), &>=/2)
  end

  defp crossover(parents, data, opts) do
    cross = Keyword.get(opts, :crossover_type, &Toolbox.Crossover.substring/3)

    parents
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
    |> Enum.reduce([], fn {p1, p2}, acc ->
      {c1, c2} = apply(cross, [p1, p2, %{}])

      [c1 | [c2 | acc]]
    end)
    |> Enum.map(&repair_chromosome(&1, data))
  end

  defp repair_chromosome(chromosome, data) do
    chromosome
    |> Repair.remove_duplicates()
    |> Repair.remove_excess_durations(data)
    |> Repair.maybe_reassign_todos(data)
  end

  defp mutation(population, data, opts) do
    mutate_fn = Keyword.get(opts, :mutation_type, &Toolbox.Mutation.bit_flip/2)
    mutation_rate = Keyword.get(opts, :mutation_rate, 0.05)

    population
    |> Enum.map(fn c ->
      if :rand.uniform() < mutation_rate do
        repair_chromosome(apply(mutate_fn, [c, data]), data)
      else
        c
      end
    end)
  end
end
