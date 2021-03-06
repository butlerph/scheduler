defmodule TTP do
  @moduledoc """
  Day-scheduling problem template
  """

  @behaviour Problem
  alias Types.Chromosome
  alias Core.Timetable

  @impl true
  @spec genotype(map()) :: Chromosome.t()
  def genotype(%{ts_size: ts_size, todo_size: todo_size} = data)
      when is_map(data) do
    genes =
      Timetable.populate(
        Matrex.zeros(ts_size, todo_size),
        Enum.shuffle(data.todo_ids),
        data
      )

    %Chromosome{genes: genes, size: Matrex.size(genes)}
  end

  @impl true
  def fitness_function(chromosome, %{todos: todos}) do
    {rows, cols} = Matrex.size(chromosome.genes)

    for row <- 1..rows do
      for col <- 1..cols do
        %{priority: p, duration: w} = Enum.at(todos, col - 1)

        p_val =
          case p do
            :none -> 1
            :low -> 2
            :medium -> 3
            :high -> 4
          end

        score =
          (rows + 1 - row) * (Matrex.at(chromosome.genes, row, col) * :math.pow(p_val, w / 60))

        score
      end
      |> Enum.sum()
    end
    |> Enum.sum()
  end

  @impl true
  def terminate?([_best | _], generation, temperature) do
    temperature < 25 || generation == 1000
  end
end
