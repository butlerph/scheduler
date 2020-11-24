defmodule Toolbox.Repair do
  def remove_duplicates(chromosome) do
    {rows, cols} = Matrex.size(chromosome.genes)

    genes =
      Enum.reduce(1..cols, chromosome.genes, fn
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

    %{chromosome | genes: genes}
  end
end
