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
      floating = {
        border = 0;
        titlebar = false;
      };
      assigns = {
        "1" = [{ app_id = "org.wezfurlong.wezter"; }];
      };
      startup = [
        { command = "wezterm start -- zellij"; }
      ];
    };
    extraConfig = ''
      default_border none
      default_floating_border none
      # font pango:monospace 0
      titlebar_border_thickness 0
      titlebar_padding 0

      for_window [app_id="org.wezfurlong.wezterm"] fullscreen enable

      # unbindsym Mod4+f
      # unbindsym Mod+Shift+space
      # unbindsym Mod4+space

      # unbindsym Mod4+1
      # unbindsym Mod4+2
      # unbindsym Mod4+3
      # unbindsym Mod4+4
      # unbindsym Mod4+5

      # unbindsym Mod4+Shift+q
      # unbindsym Mod4+Left
      # unbindsym Mod4+Right
      # unbindsym Mod4+Up
      # unbindsym Mod4+Down
      
      bindsym Mod4+Shift+e exec swaymsg exit
    '';
  };
}
