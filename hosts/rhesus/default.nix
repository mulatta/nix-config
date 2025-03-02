{ pkgs, ... }:
{
  imports = [
    ../shared/darwin
    ./environments.nix
    ./dock.nix
  ];
}
