{ config, pkgs, ... }:
{
  # List services that you want to enable:
  services.xserver.enable = false;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = false;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
    ];
  };
  services.displayManager.ly = {
    enable = true;
    # defaultUser = "mulatta";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    TERM = "wezterm";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    grim
    slurp
  ];
}
