defmodule Toolbox.Repair do
  alias Core.Todo
  alias Helpers.MatrixHelper

  def remove_duplicates(%{genes: genes} = chromosome) do
    {rows, cols} = Matrex.size(genes)

    new_genes =
      Enum.reduce(1..cols, genes, fn
        col_num, genes ->
          id_col = Matrex.submatrix(genes, 1..rows, col_num..col_num)

          case Matrex.find(id_col, 1) do
            nil ->
              genes

            {m_row, _m_col} ->
              genes
              |> Matrex.set_column(col_num, Matrex.zeros(rows, 1))
              |> Matrex.set(m_row, col_num, 1)
          end
      end)

    %{chromosome | genes: new_genes}
  end

  def remove_excess_durations(
        %{genes: genes} = chromosome,
        %{durations: durations, time_streak_weights: tsw} = data
      ) do
    {rows, cols} = Matrex.size(genes)
    # Remove todos that cause it to exceed.
    # Should be according to ascending order

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
end
