defmodule Core.TimeStreak do
  # alias Types.Range

  def get_weights(time_streaks, :list) when is_list(time_streaks) do
    Enum.map(time_streaks, fn {from, to} ->
      Timex.diff(to, from, :minutes)
    end)
  end

  def get_weights(time_streaks, :matrix) when is_list(time_streaks) do
    weights =
      Enum.map(time_streaks, fn {from, to} ->
        Timex.diff(to, from, :minutes)
      end)

    Matrex.new([weights])
  end

  def count_unfilled_streaks(current_streak_weights, time_streak_weights) do
    current_streak_weights
    |> Enum.with_index()
    |> Enum.map(fn {w, index} ->
      expected_max = Enum.at(time_streak_weights, index, 0)

      if w < expected_max do
        1
      else
        0
      end
    end)
    |> Enum.sum()
  end
end
