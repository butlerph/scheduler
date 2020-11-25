defmodule Problem do
  alias Types.Chromosome

  @callback genotype(any()) :: Chromosome.t()

  @callback fitness_function(Chromosome.t(), map()) :: number()

  @callback terminate?(Enum.t(), integer(), integer()) :: boolean()
end
