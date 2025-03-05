{ pkgs, ... }:
{
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
