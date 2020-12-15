defmodule Core.TimeStreak do
  # alias Types.Range

  def get_durations(time_streaks, :list) when is_list(time_streaks) do
    Enum.map(time_streaks, fn {from, to} ->
      Timex.diff(to, from, :minutes)
    end)
  end

  def get_durations(time_streaks, :matrix) when is_list(time_streaks) do
    durations =
      Enum.map(time_streaks, fn {from, to} ->
        Timex.diff(to, from, :minutes)
      end)

    Matrex.new([durations])
  end

  def count_unfilled_streaks(current_streak_durations, time_streak_durations) do
    current_streak_durations
    |> Enum.with_index()
    |> Enum.map(fn {d, index} ->
      expected_max = Enum.at(time_streak_durations, index, 0)

      if d < expected_max do
        1
      else
        0
      end
    end)
    |> Enum.sum()
  end
end
