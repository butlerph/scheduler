defmodule Toolbox.Crossover do
  alias Types.Chromosome
  alias Helpers.MatrixHelper

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

    row_cx = :random.uniform(rows)
    col_cx = :random.uniform(cols)

    c1 = MatrixHelper.fuse(p1.genes, p2.genes, {row_cx, col_cx}, :rows)
    c2 = MatrixHelper.fuse(p2.genes, p1.genes, {row_cx, col_cx}, :rows)

    {%Chromosome{genes: c1, size: 0}, %Chromosome{genes: c2, size: 0}}
  end
end
