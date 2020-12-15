defmodule Toolbox.Repair do
  alias Core.Todo
  alias Helpers.MatrixHelper
  alias Core.Timetable

  @doc """
  A timetable matrix column should contain at most 1 occurrence of `1.0`.
  All other occurrences are removed.
  """
  def remove_duplicates(%{genes: genes} = chromosome) do
    {rows, cols} = Matrex.size(genes)

    new_genes =
      1..cols
      |> Enum.map(fn col_num ->
        Task.async(fn ->
          remove_col_duplicate(genes, rows, col_num)
        end)
      end)
      |> Enum.map(&Task.await/1)
      |> Matrex.concat()

    %{chromosome | genes: new_genes}
  end

  defp remove_col_duplicate(genes, rows, col_num) do
    id_col = Matrex.submatrix(genes, 1..rows, col_num..col_num)

    case Matrex.find(id_col, 1) do
      nil ->
        id_col

      {m_row, _m_col} ->
        rows
        |> Matrex.zeros(1)
        |> Matrex.set(m_row, 1, 1)
    end
  end

  @doc """
  If there are any time slots whose todos exceed its capacity, todos will be
  removed according to lowest fitness.
  """
  def remove_excess_durations(
        %{genes: genes} = chromosome,
        %{durations: durations, time_streak_durations: tsw} = data
      ) do
    {rows, cols} = Matrex.size(genes)

    new_genes =
      Enum.reduce(1..rows, genes, fn row, new_genes ->
        streak_duration = Matrex.at(tsw, 1, row)

        actual_duration =
          for col <- 1..cols do
            Matrex.at(genes, row, col) * Matrex.at(durations, 1, col)
          end
          |> Enum.sum()

        if actual_duration > streak_duration do
          streak_row = Matrex.submatrix(genes, row..row, 1..cols)
          new_row = Todo.remove_excess(streak_row, actual_duration - streak_duration, data)
          MatrixHelper.update_row(new_genes, row, new_row)
        else
          new_genes
        end
      end)

    %{chromosome | genes: new_genes}
  end

  @doc """
  Attempt to reassign todos through First-Fit decreasing.
  """
  def maybe_reassign_todos(
        %{genes: genes} = chromosome,
        %{
          todo_ids: all_ids,
          durations: d,
          priorities: p
        } = data
      ) do
    unused_todos =
      genes
      |> Timetable.list_unused_todos(all_ids)
      |> Enum.sort_by(
        fn id ->
          priority = Matrex.at(p, 1, id)
          duration = Matrex.at(d, 1, id)

          :math.pow(priority, duration / 60)
        end,
        &>=/2
      )

    new_genes = Timetable.populate(genes, unused_todos, data)

    %{chromosome | genes: new_genes}
  end
end
