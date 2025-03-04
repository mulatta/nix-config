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
        "1" = [{ app_id = "org.wezfurlong.wezterm"; }];
      };
      startup = [
        { command = "wezterm start -- zellij"; always = true; }
      ];
    };
    extraConfig = ''
      for_window [app_id="org.wezfurlong.wezterm"] {
        border none  
        fullscreen enable
      } 
   
      bindsym Mod4+Shift+e exec swaymsg exit
    '';
  };
}
