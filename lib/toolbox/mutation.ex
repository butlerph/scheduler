defmodule Toolbox.Mutation do
  use Bitwise

  def bit_flip(%{genes: genes} = chromosome, _data) do
    {rows, cols} = Matrex.size(genes)
    row = :random.uniform(rows)
    col = :random.uniform(cols)
    flipped_bit = trunc(Matrex.at(genes, row, col)) ^^^ 1

    %{chromosome | genes: Matrex.set(genes, row, col, flipped_bit)}
  end
end
