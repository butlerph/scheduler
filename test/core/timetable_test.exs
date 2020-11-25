defmodule TimetableTest do
  use ExUnit.Case
  alias Core.Timetable

  describe "populate matrix with todos based on score" do
    test "populates all todos" do
      time_streaks = Scheduler.time_streaks()

      todos = Scheduler.todos()
      time_streak_weights = Core.TimeStreak.get_weights(time_streaks, :matrix)
      todo_durations = Core.Todo.to_duration_matrix(todos)
      todo_priorities = Core.Todo.to_priority_matrix(todos)

      data = %{
        todo_ids: Enum.map(todos, fn %{id: id} -> id end),
        time_streak_weights: time_streak_weights,
        durations: todo_durations
      }

      unused_todos =
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        |> Enum.sort_by(
          fn id ->
            priority = Matrex.at(todo_priorities, 1, id)
            duration = Matrex.at(todo_durations, 1, id)

            :math.pow(priority, duration)
          end,
          &>=/2
        )

      blank_tt = Matrex.zeros(12, 10)
      populated = Timetable.populate(blank_tt, unused_todos, data)

      assert populated |> Timetable.list_unused_todos(data.todo_ids) == []
    end
  end
end
