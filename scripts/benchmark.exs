# Sample schedule of availability [{from, to}, ...]
time_streaks = Scheduler.time_streaks()

# Sample todos
todos = Scheduler.todos()
time_streak_durations = Core.TimeStreak.get_durations(time_streaks, :matrix)
todo_durations = Core.Todo.to_duration_matrix(todos)
todo_priorities = Core.Todo.to_priority_matrix(todos)

# Data to be accessed by the GA
data = %{
  todo_ids: Enum.map(todos, fn %{id: id} -> id end),
  todos: todos,
  todo_size: length(todos),
  ts_size: length(time_streaks),
  time_streaks: time_streaks,
  time_streak_durations: time_streak_durations,
  durations: todo_durations,
  priorities: todo_priorities,
}

elitist_opts = [
  population_size: 100,
  reinsertion_type: &Toolbox.Reinsertion.elitist/4
]

pure_opts = [
  population_size: 100,
  reinsertion_type: &Toolbox.Reinsertion.pure/4
]

Benchee.run(
  %{
    "Elitist" => fn data -> Genetic.run(TTP, data, elitist_opts) end,
    "Pure" => fn data -> Genetic.run(TTP, data, pure_opts) end
  },
  inputs: %{
    small: data,
  }
)
