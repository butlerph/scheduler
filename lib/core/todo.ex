defmodule Core.Todo do
  alias Core.Timetable

  @doc """
  Finds a random tasks that can fit the max weight
  """
  def find_tasks_within_weight(todos, chosen_todos \\ [], max_weight, continue? \\ true)

  def find_tasks_within_weight(todos, chosen_todos, _, false), do: {todos, chosen_todos}

  def find_tasks_within_weight([], chosen_todos, _, true), do: {[], chosen_todos}

  def find_tasks_within_weight([_ | _] = todos, chosen_todos, max_weight, true) do
    # Get all todos that are within `max_weight`.
    eligible_todos = Enum.filter(todos, fn %{weight: w} -> w <= max_weight end)

    {new_todos, new_weight, new_chosen_todos, continue?} =
      case eligible_todos do
        [] ->
          {todos, max_weight, [], false}

        eligible_todos ->
          %{id: todo_id} =
            chosen_todo =
            eligible_todos
            |> Enum.random()

          new_todos = Enum.filter(todos, fn todo -> todo != chosen_todo end)
          new_weight = max_weight - chosen_todo.weight

          {new_todos, new_weight, [todo_id], true}
      end

    new_chosen_todos = chosen_todos ++ new_chosen_todos

    find_tasks_within_weight(new_todos, new_chosen_todos, new_weight, continue?)
  end

  def get_todo(todos, todo_id) do
    Enum.find(todos, fn t -> t.id == todo_id end)
  end

  def update_todo(todos, todo_id, todo_attrs \\ %{}) do
    case get_todo(todos, todo_id) do
      nil ->
        {:error, "Todo does not exist"}

      %Types.Todo{} = todo ->
        {:ok, update(todo, todo_attrs)}
    end
  end

  defp update(todo, todo_attrs) do
    keys = Map.keys(todo_attrs)
    values = Map.values(todo_attrs)
    kvps = Enum.zip(keys, values)

    Enum.reduce(kvps, todo, fn {k, v}, t ->
      Map.put(t, k, v)
    end)
  end

  def to_duration_matrix(todos) do
    todos
    |> Enum.map(fn %{weight: w} ->
      w
    end)
    |> (fn x -> [x] end).()
    |> Matrex.new()
  end

  def to_priority_matrix(todos) do
    todos
    |> Enum.map(fn %{priority: p} ->
      p
    end)
    |> (fn x -> [x] end).()
    |> Matrex.new()
  end

  @doc """
  Removes excess todos from the submatrix (represents a row in the Matrix).
  """
  def remove_excess(streak, duration_to_remove, %{durations: d, priorities: p}) do
    {_rows, cols} = Matrex.size(streak)

    todo_ids =
      streak
      |> Matrex.to_list()
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {1.0, todo_index}, acc ->
          [todo_index + 1 | acc]

        {0.0, _}, acc ->
          acc
      end)

    sorted_todo_ids =
      Enum.sort_by(
        todo_ids,
        fn id ->
          priority = Matrex.at(p, 1, id)
          duration = Matrex.at(d, 1, id)

          :math.pow(priority, duration)
        end
      )

    # Keep dropping IDs until duration does not exceed
    Enum.reduce_while(sorted_todo_ids, {sorted_todo_ids, duration_to_remove}, fn
      todo_id, {ids, remaining_duration} = acc ->
        cond do
          remaining_duration > 0 ->
            todo_duration = Matrex.at(d, 1, todo_id)
            new_acc = {Enum.drop(ids, 1), remaining_duration - todo_duration}

            {:cont, new_acc}

          true ->
            {:halt, acc}
        end
    end)
    |> elem(0)
    |> Enum.reduce(Matrex.zeros(1, cols), fn id, acc ->
      Matrex.set(acc, 1, id, 1)
    end)
  end
end
