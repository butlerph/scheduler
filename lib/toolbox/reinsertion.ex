defmodule Toolbox.Reinsertion do
  def pure(_parents, children, _leftovers, _opts), do: children

  def elitist(parents, offspring, leftovers, opts) do
    survival_rate = Keyword.get(opts, :survival_rate, 0.2)

    old = parents ++ leftovers
    n = floor(length(old) * survival_rate)

    survivors =
      old
      |> Enum.sort_by(fn x -> x.fitness end, &>=/2)
      |> Enum.take(n)

    offspring ++ survivors
  end
end
