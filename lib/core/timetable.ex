defmodule Core.Timetable do
  @moduledoc """
  Timetable is just a formatted representation
  of the results generated by the GA.
  """

  alias Core.Todo

  @doc """
  Populates the matrix with todos based on First-Fit decreasing order.
  """
  def populate(
        timetable,
        unassigned_todos,
        %{time_streak_weights: tsw, durations: d} = data
      ) do
    {rows, _cols} = Matrex.size(timetable)

    Enum.reduce(unassigned_todos, timetable, fn
      todo_id, new_tt ->
        todo_weight = Matrex.at(d, 1, todo_id)

        Enum.reduce_while(1..rows, new_tt, fn row_num, new_tt ->
          max_capacity = Matrex.at(tsw, 1, row_num)
          current_streak_weight = get_streak_weight(new_tt, row_num, data)
          allowance = max_capacity - current_streak_weight

          cond do
            todo_weight <= allowance ->
              new_tt = Matrex.set(new_tt, row_num, todo_id, 1)
              {:halt, new_tt}

            true ->
              {:cont, new_tt}
          end
        end)
    end)
  end

  def list_unused_todos(timetable, all_todos) do
    timetable
    |> Matrex.to_list_of_lists()
    |> from_bit_timetable()
    |> List.flatten()
    |> MapSet.new()
    |> (fn a -> MapSet.difference(MapSet.new(all_todos), a) end).()
    |> MapSet.to_list()
  end

  def from_bit_timetable(timetable) do
    Enum.map(timetable, fn time_streak ->
      time_streak
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {1.0, index}, acc ->
          [index + 1 | acc]

        _, acc ->
          acc
      end)
    end)
  end

  @doc """
  Synchronizes the result of the GA with the todos
  """
  def from_schedule(timetable, todos, time_streaks) do
    timetable
    |> Enum.with_index()
    |> Enum.map(fn {streak_todos, index} ->
      {todos, _} =
        case Enum.at(time_streaks, index) do
          nil ->
            raise "Time streak does not exist given the index #{index}"

          {from, _to} ->
            Enum.reduce(streak_todos, {[], 0}, fn
              todo_id, {curr_streak_todos, offset} ->
                duration_offset = Timex.Duration.from_minutes(offset)
                todo = Todo.get_todo(todos, todo_id)
                duration = Timex.Duration.from_minutes(todo.duration)

                from = Timex.add(from, duration_offset)
                to = Timex.add(from, duration)

                case Todo.update_todo(todos, todo_id, %{from: from, to: to}) do
                  {:error, _} ->
                    raise "Something went wrong in updating"

                  {:ok, new_todo} ->
                    new_curr_streak_todos = curr_streak_todos ++ [new_todo]
                    {new_curr_streak_todos, offset + Timex.diff(to, from, :minutes)}
                end
            end)
        end

      todos
    end)
    |> List.flatten()
  end

  @doc """
  Prints out a readable timetable for humans.
  """
  def print(timetable, todos, time_streaks) do
    IO.puts("""
    \nNOTE: Do not print in production. Only use `Timetable.print(...)`
    for debugging purposes.
    """)

    timetable
    |> from_schedule(todos, time_streaks)
    |> Scribe.print(data: [:id, :name, :priority, :duration, :from, :to])
  end

  def get_streak_capacity(streak, todos) do
    Enum.map(streak, fn todo_id ->
      todo = Todo.get_todo(todos, todo_id)

      todo.duration
    end)
    |> Enum.sum()
  end

  def get_timetable_capacity(timetable, todos) do
    Enum.map(timetable, fn streak ->
      get_streak_capacity(streak, todos)
    end)
  end

  def shuffle(timetable) do
    Enum.map(timetable, fn streak ->
      Enum.shuffle(streak)
    end)
  end

  @doc """
  This just sorts the tasks in the streak based on priority. This does not
  affect the fitness score in any way.
  """
  def sort_todos(timetable, todos) do
    Enum.map(timetable, fn streak ->
      Enum.sort_by(
        streak,
        fn todo_id ->
          %{priority: p} = Todo.get_todo(todos, todo_id)

          p
        end,
        :desc
      )
    end)
  end

  def get_streak_weight(timetable, row, %{durations: d}) do
    {_, cols} = Matrex.size(timetable)

    Matrex.submatrix(timetable, row..row, 1..cols)
    |> Enum.with_index()
    |> Enum.reduce([], fn
      {1.0, todo_index}, acc ->
        [todo_index + 1 | acc]

      {0.0, _}, acc ->
        acc
    end)
    |> Enum.reduce(0, fn todo_id, weight_score ->
      weight_score + Matrex.at(d, 1, todo_id)
    end)
  end
end
