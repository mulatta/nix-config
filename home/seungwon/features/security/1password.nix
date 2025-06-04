{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optional;
  inherit (pkgs.hostPlatform) isLinux;
in {
  home.packages = with pkgs;
    [
      _1password-cli
    ]
    ++ optional isLinux _1password-gui;
}
