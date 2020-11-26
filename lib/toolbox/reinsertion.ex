defmodule Toolbox.Reinsertion do
  def pure(_parents, offspring, _leftovers, _opts), do: offspring

  def elitist(parents, offspring, leftovers, opts) do
    # IO.inspect(parents, label: "Parents")
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
