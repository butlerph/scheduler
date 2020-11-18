defmodule Toolbox.Mutation do
  # alias Core.TimeStreak
  alias Core.Timetable

  # TODO: Remove after proper mutation function is created.
  def scramble(chromosome, _data) do
    genes = Timetable.shuffle(chromosome.genes)

    %{chromosome | genes: genes}
  end
end
