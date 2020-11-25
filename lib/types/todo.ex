defmodule Types.Todo do
  @type t() :: %__MODULE__{
          id: integer(),
          subject: String.t(),
          name: String.t(),
          weight: integer(),
          priority: integer(),
          from: NaiveDateTime.t(),
          to: NaiveDateTime.t()
        }

  @enforce_keys [:id, :name]
  defstruct [:id, :subject, :name, :from, :to, weight: 1, priority: 0]
end
