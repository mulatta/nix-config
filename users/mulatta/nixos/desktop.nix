{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.startx = {
      enable = true;
      session = ''
        exec ${pkgs.wezterm}/bin/wezterm
      '';
    };
    windowManager.default = "none";
  };

  environment.systemPackages = with pkgs;[
    xterm
    noto-fonts
  ];
}
