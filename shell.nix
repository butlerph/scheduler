{ pkgs ? import <nixpkgs> {} }:
  
with pkgs;

let
  inherit (lib) optional optionals;

  erlang = beam.interpreters.erlangR23;
  elixir = beam.packages.erlangR23.elixir_1_11;
in

mkShell {
  buildInputs = [git erlang elixir]
    ++ optional stdenv.isLinux inotify-tools;

    shellHook = ''
      export LANG=C.UTF-8
    '';
}