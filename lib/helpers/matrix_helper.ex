defmodule Helpers.MatrixHelper do
  @moduledoc """
  Convenience functions for dealing with matrices.
  """

  @doc """
  Fuses 2 rows at a crossover point. This assumes both rows have the same
  dimensions.
  """
  def fuse_rows(row_a, row_b, cx_point) do
    case Matrex.size(row_a) do
      {1, 1} ->
        row_a

      {_, cols} ->
        cond do
          cx_point < cols ->
            Matrex.concat(
              Matrex.submatrix(row_a, 1..1, 1..cx_point),
              Matrex.submatrix(row_b, 1..1, (cx_point + 1)..cols),
              :columns
            )

          cx_point == cols ->
            Matrex.concat(
              Matrex.submatrix(row_a, 1..1, 1..(cx_point - 1)),
              Matrex.submatrix(row_b, 1..1, cx_point..cols),
              :columns
            )
        end
    end
  end

  @doc """
  Fuses two matrices together at the row and column points.
  """
  def fuse(m1, m2, {row_cx, col_cx}, :rows) do
    case Matrex.size(m1) do
      {1, 1} ->
        m1

      {1, _cols} ->
        fuse_rows(m1, m2, col_cx)

      {rows, cols} ->
        fused_row1 =
          fuse_rows(
            Matrex.submatrix(m1, row_cx..row_cx, 1..cols),
            Matrex.submatrix(m2, row_cx..row_cx, 1..cols),
            col_cx
          )

        cond do
          row_cx == 1 ->
            second_half = (row_cx + 1)..rows

            [
              fused_row1,
              Matrex.submatrix(m2, second_half, 1..cols)
            ]

          row_cx < rows ->
            first_half = 1..(row_cx - 1)
            second_half = (row_cx + 1)..rows

            [
              Matrex.submatrix(m1, first_half, 1..cols),
              fused_row1,
              Matrex.submatrix(m2, second_half, 1..cols)
            ]

          row_cx == rows ->
            first_half = 1..(row_cx - 1)

            [
              Matrex.submatrix(m1, first_half, 1..cols),
              fused_row1
            ]
        end
        |> concat_rows()
    end
  end

  @doc """
  Concatenates multiple rows into one matrix.
  """
  def concat_rows(rows) when is_list(rows) do
    Matrex.reshape(rows, 1, 1)
  end

  @doc """
  Updates a row in a matrix with a new row.
  """
  def update_row(m, row_cx, m_row) do
    {rows, cols} = Matrex.size(m)

    cond do
      row_cx == 1 ->
        second_half = (row_cx + 1)..rows

        [
          m_row,
          Matrex.submatrix(m, second_half, 1..cols)
        ]

      row_cx < rows ->
        first_half = 1..(row_cx - 1)
        second_half = (row_cx + 1)..rows

        [
          Matrex.submatrix(m, first_half, 1..cols),
          m_row,
          Matrex.submatrix(m, second_half, 1..cols)
        ]

      row_cx == rows ->
        first_half = 1..(row_cx - 1)

        [
          Matrex.submatrix(m, first_half, 1..cols),
          m_row
        ]
    end
    |> concat_rows()
  end
end
