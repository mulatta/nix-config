{ pkgs, ... }:
{
  imports = [
    ../shared/darwin
    ./system-pkgs.nix
    ./dock.nix
  ];
}
