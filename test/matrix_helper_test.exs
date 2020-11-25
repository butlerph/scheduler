defmodule MatrixHelperTest do
  use ExUnit.Case
  alias Helpers.MatrixHelper

  describe "fuse two matrices" do
    test "where row_cx < rows, col_cx < cols" do
      m1 = Matrex.zeros(2, 5)
      m2 = Matrex.ones(2, 5)

      fused_matrix = MatrixHelper.fuse(m1, m2, {2, 1}, :rows)

      expected_matrix = Matrex.new([[0, 0, 0, 0, 0], [0, 1, 1, 1, 1]])

      assert fused_matrix == expected_matrix
    end

    test "where row_cx == 1 and rows > 1, and col_cx < cols" do
      m1 = Matrex.zeros(2, 5)
      m2 = Matrex.ones(2, 5)

      fused_matrix = MatrixHelper.fuse(m1, m2, {1, 3}, :rows)

      expected_matrix = Matrex.new([[0, 0, 0, 1, 1], [1, 1, 1, 1, 1]])

      assert fused_matrix == expected_matrix
    end
  end

  describe "update row of matrix with a new row" do
    test "update first row" do
      m = Matrex.zeros(2, 3)
      row_to_insert = Matrex.ones(1, 3)
      new_matrix = MatrixHelper.update_row(m, 1, row_to_insert)

      assert new_matrix == Matrex.new([[1, 1, 1], [0, 0, 0]])
    end

    test "update last row" do
      m = Matrex.zeros(2, 3)
      row_to_insert = Matrex.ones(1, 3)
      new_matrix = MatrixHelper.update_row(m, 2, row_to_insert)

      assert new_matrix == Matrex.new([[0, 0, 0], [1, 1, 1]])
    end
  end
end
