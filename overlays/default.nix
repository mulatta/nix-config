# overlay/default.nix
{ inputs, ... }:

final: prev:
let
  overlays = [
    (import ./custom-scripts)
  ];
in
builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } overlays
