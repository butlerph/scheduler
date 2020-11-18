defmodule Core.Todo do
  @doc """
  Finds a random tasks that can fit the max weight
  """
  def find_tasks_within_weight(todos, chosen_todos \\ [], max_weight, continue? \\ true)

  def find_tasks_within_weight(todos, chosen_todos, _, false), do: {todos, chosen_todos}

  def find_tasks_within_weight([], chosen_todos, _, true), do: {[], chosen_todos}

  def find_tasks_within_weight([_ | _] = todos, chosen_todos, max_weight, true) do
    eligible_todos =
      todos
      |> Enum.filter(fn %{weight: w} -> w <= max_weight end)

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
end
