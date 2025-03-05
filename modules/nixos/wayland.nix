{ pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
  };
  services.xserver.enable = false;
  security.polkit.enable = true;

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
