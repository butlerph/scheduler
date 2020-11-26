defmodule Toolbox.Selection do
  def natural(population, n, _opts) do
    Enum.take(population, n)
  end
end
