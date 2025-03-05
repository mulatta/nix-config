{ config, pkgs, ... }:
{
  # List services that you want to enable:
  services.xserver.enable = false;
  security.polkit.enable = true;
}
