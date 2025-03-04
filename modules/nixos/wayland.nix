{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "wezterm";
      menu = "";
      bars = [ ];
      window = {
        border = 0;
        titlebar = false;
      };
      startup = [
        { command = "wezterm start -- zellij"; }
      ];
      extraConfig = ''
        output * bg #000000 solid_color
      '';
    };
  };
}
