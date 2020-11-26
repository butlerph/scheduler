defmodule Toolbox.Selection do
  def natural(population, n, _opts) do
    Enum.take(population, n)
  end

  # def unique_tournament(population, n, opts) do
  #   size = Keyword.get(opts, :tournament_size, 3)
  #   selected = MapSet.new()

  #   unique_tournament_helper(population, n, size, selected)
  # end

  # defp unique_tournament_helper(population, n, size, selected) do
  #   if MapSet.size(selected) == n do
  #     MapSet.to_list(selected)
  #   else
  #     chosen =
  #       population
  #       |> Enum.take_random(size)
  #       |> Enum.max_by(& &1.fitness)

  #     unique_tournament_helper(population, n, size, MapSet.put(selected, chosen))
  #   end
  # end
end
