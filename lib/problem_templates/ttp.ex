defmodule TTP do
  @moduledoc """
  Day-scheduling problem template
  """

  @behaviour Problem
  alias Types.Chromosome
  alias Core.Todo

  @impl true
  @spec genotype(map()) :: Chromosome.t()
  def genotype(%{todos: todos, time_streak_weights: tsw, size: size} = data)
      when is_map(data) do
    # TODO: Find a better way to generate genotype without list -> matrix.
    {_, timetable} =
      Enum.reduce(tsw, {todos, []}, fn
        streak_weight, {todos_left, chosen_todos} ->
          result = Todo.find_tasks_within_weight(todos_left, streak_weight)
          {todos_left, new_chosen} = result

          {todos_left, chosen_todos ++ [new_chosen]}
      end)

    genes =
      Enum.map(timetable, fn time_streak ->
        todo_slots =
          Stream.repeatedly(fn -> 0 end)
          |> Enum.take(size)

        Enum.reduce(time_streak, todo_slots, fn todo_id, slots ->
          List.replace_at(slots, todo_id - 1, 1)
        end)
      end)
      |> Matrex.new()

    %Chromosome{genes: genes, size: 0}
  end

  @impl true
  def fitness_function(chromosome, %{todos: todos}) do
    {rows, cols} = Matrex.size(chromosome.genes)

    for row <- 1..rows do
      for col <- 1..cols do
        %{priority: p, weight: w} =
          todos
          |> Enum.find(fn t -> t.id == col end)

        (rows + 1 - row) * (Matrex.at(chromosome.genes, row, col) * :math.pow(p, w / 60))
      end
      |> Enum.sum()
    end
    |> Enum.sum()
  end

  @impl true
  def terminate?([_best | _], generation, temperature) do
    temperature < 25 || generation == 1000
    # generation == 1000
  end
end
