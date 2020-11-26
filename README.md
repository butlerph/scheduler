# Scheduler

Personal, automated weekly task scheduler used by Butler.

This doesn't aim to be a framework for GAs in Elixir. If you're looking for one,
you'll want to look into [Genex](https://github.com/seanmor5/genex). Butler
essentially copied over the structure of it, except it's very specific to its
use case only.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `scheduler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scheduler, "~> 0.1.0"}
  ]
end
```

## Building this locally

Install Nix package manager and run this in your terminal

```bash
nix-shell
```

This creates a new, isolated environment with Erlang/Elixir installed.

## Running a problem

This comes with one problem and some sample data. To run the problem, run this
in your terminal:

```bash
$ mix run scripts/run_problem.exs

# Output
[5000 Current best 6990539.405494426
===========> BEST SOLUTION
-----------> Fitness: 6990539.405494426
-----------> Genes
[[2], [4, 8, 1], [9, 6, 3], '\n\a', [], [], [], [5], [], [], [], []]
[[2], [4, 8, 1], [6, 9, 3], '\a\n', [], [], [], [5], [], [], [], []]

NOTE: Do not print in production. Only use `Timetable.print(...)`
for debugging purposes.

# Removed table output
```

It should print the table as well, but because it cannot fit here, I removed it.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/scheduler](https://hexdocs.pm/scheduler).

