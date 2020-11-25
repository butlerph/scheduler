defmodule Scheduler do
  @moduledoc """
  Everything needed as input for Genetic module.
  """
  alias Types.Todo

  @doc """
  Sample data for todos
  """
  def todos do
    [
      %Todo{id: 1, name: "CS280: Test Section 5", weight: 180, priority: 4},
      %Todo{id: 2, name: "CS210: Finish Week #1 HW", weight: 180, priority: 4},
      %Todo{id: 3, name: "Feed Hiro water", weight: 5, priority: 1},
      %Todo{id: 4, name: "Write TP #1", weight: 180, priority: 4},
      %Todo{id: 5, name: "CS280: Study week topic", weight: 240, priority: 4},
      %Todo{id: 6, name: "Study Haskell", weight: 120, priority: 2},
      %Todo{id: 7, name: "Write TP #2", weight: 180, priority: 3},
      %Todo{id: 8, name: "Read Pragmatic Programmer Book", weight: 60, priority: 4},
      %Todo{id: 9, name: "Sound the horn", weight: 1, priority: 1},
      %Todo{id: 10, name: "CS210: Prepare for final project", weight: 180, priority: 1}
    ]
  end

  @doc """
  Sample data for time streaks
  """
  def time_streaks do
    [
      {~N[2020-11-18 09:00:00.00], ~N[2020-11-18 12:00:00.00]},
      {~N[2020-11-18 13:00:00.00], ~N[2020-11-18 20:00:00.00]},
      {~N[2020-11-19 09:00:00.00], ~N[2020-11-19 12:00:00.00]},
      {~N[2020-11-19 13:00:00.00], ~N[2020-11-19 20:00:00.00]},
      {~N[2020-11-20 09:00:00.00], ~N[2020-11-20 12:00:00.00]},
      {~N[2020-11-20 13:00:00.00], ~N[2020-11-20 15:00:00.00]},
      {~N[2020-11-21 09:00:00.00], ~N[2020-11-21 12:00:00.00]},
      {~N[2020-11-21 13:00:00.00], ~N[2020-11-21 20:00:00.00]},
      {~N[2020-11-22 09:00:00.00], ~N[2020-11-22 12:00:00.00]},
      {~N[2020-11-22 13:00:00.00], ~N[2020-11-22 20:00:00.00]},
      {~N[2020-11-23 09:00:00.00], ~N[2020-11-23 12:00:00.00]},
      {~N[2020-11-23 13:00:00.00], ~N[2020-11-23 15:00:00.00]}
    ]
  end
end
