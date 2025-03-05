{ config, pkgs, ... }:
{
  # List services that you want to enable:
  services.xserver.enable = false;
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = false;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
    ];
  };
}
