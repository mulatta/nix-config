{ config, pkgs, lib, ... }:
{
  home.packages = [
    pkgs.ghostty
  ];
  xdg.configFile."ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/ghostty/config";
  };
}
