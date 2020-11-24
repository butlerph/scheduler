defmodule Toolbox.Crossover do
  alias Types.Chromosome

  @doc """
  2D substring crossover
  """
  def substring(p1, p2, data) do
    # TODO: Add vertical crossover
    # TODO: 50-50 for horizontal and vertical
    horizontal(p1, p2, data)
  end

  def horizontal(p1, p2, _data) do
    {rows, cols} = Matrex.size(p1.genes)

    # IO.puts("LOLOL #{inspect(rows)}:#{inspect(cols)}")

    row_cx = :random.uniform(rows)
    # col_cx = :random.uniform(cols)

    # IO.inspect(row_cx)

    {c1, c2} =
      if row_cx < 12 do
        {
          Matrex.concat(
            Matrex.submatrix(p1.genes, 1..row_cx, 1..cols),
            Matrex.submatrix(p2.genes, (row_cx + 1)..rows, 1..cols),
            :rows
          ),
          Matrex.concat(
            Matrex.submatrix(p2.genes, 1..row_cx, 1..cols),
            Matrex.submatrix(p1.genes, (row_cx + 1)..rows, 1..cols),
            :rows
          )
        }
      else
        {p1.genes, p2.genes}
      end

    {%Chromosome{genes: c1, size: 0}, %Chromosome{genes: c2, size: 0}}
  end
end
