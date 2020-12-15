defmodule Scheduler do
  @moduledoc """
  Everything needed as input for Genetic module.
  """

  @doc """
  Sample data for todos
  """
  def todos do
    [
      %{id: "a", name: "CS280: Test Section 5", duration: 180, priority: :high},
      %{id: "2", name: "CS210: Finish Week #1 HW", duration: 180, priority: :high},
      %{id: "3", name: "Feed Hiro water", duration: 5, priority: :low},
      %{id: "4", name: "Write TP #1", duration: 180, priority: :high},
      %{id: "5", name: "CS280: Study week topic", duration: 240, priority: :high},
      %{id: "6", name: "Study Haskell", duration: 120, priority: :low},
      %{id: "7", name: "Write TP #2", duration: 180, priority: :medium},
      %{id: "8", name: "Read Pragmatic Programmer Book", duration: 60, priority: :medium},
      %{id: "9", name: "Sound the horn", duration: 1, priority: :none},
      %{id: "10", name: "CS210: Prepare for final project", duration: 180, priority: :none}
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
