defmodule TTP do
  @moduledoc """
  Day-scheduling problem template
  """

  @behaviour Problem
  alias Types.Chromosome
  alias Core.Todo

  @impl true
  @spec genotype(map()) :: Chromosome.t()
  def genotype(%{todos: todos, time_streak_weights: tsw} = data)
      when is_map(data) do
    {_, genes} =
      Enum.reduce(tsw, {todos, []}, fn
        streak_weight, {todos_left, chosen_todos} ->
          result = Todo.find_tasks_within_weight(todos_left, streak_weight)
          {todos_left, new_chosen} = result

          {todos_left, chosen_todos ++ [new_chosen]}
      end)

    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness_function(chromosome, %{todos: todos, time_streak_weights: tsw}) do
    length = length(chromosome.genes)

    chromosome.genes
    |> Enum.with_index()
    |> Enum.map(fn {streak, streak_index} ->
      streak_weight = Enum.at(tsw, streak_index, 1)
      # streak_length = length(streak)

      streak
      |> Enum.with_index()
      |> Enum.map(fn {todo_id, _todo_index} ->
        todo = Todo.get_todo(todos, todo_id)

        todo.priority * todo.weight / 100
      end)
      |> Enum.sum()
      |> Kernel./(streak_weight)
      |> :math.pow(length + 1 - streak_index)
    end)
    |> Enum.sum()
    |> Kernel./(length)
  end

  @impl true
  def terminate?([_best | _], generation, temperature) do
    # temperature < 25 || generation == 1000
    generation == 5000
  end
end
