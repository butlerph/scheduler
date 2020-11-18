# Scheduler

Personal, automated weekly task scheduler used by Butler.

## Building this locally

Install Nix package manager and run this in your terminal

```bash
nix-shell
```

This creates a new, isolated environment with Erlang/Elixir installed.

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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/scheduler](https://hexdocs.pm/scheduler).

