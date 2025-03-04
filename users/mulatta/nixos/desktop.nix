{ config, pkgs, ... }:
{
  # List services that you want to enable:
  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;

    desktopManager = {
      xterm.enable = false;
      xfce.enable = false;
      gnome.enable = false;
      plasma6.enable = false;
      lxqt.enable = false;

      defaultSession = "none";
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.xinit
    xorg.xauth
  ];

  home.file.".xinitrc".text = ''
    #!/bin/sh
  
    [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
  
    xsetroot -solid "#1a1b26"
  
    exec wezterm
  '';
}
