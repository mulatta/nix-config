{
  programs.wezterm.extraConfig = ''
    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()
    config.exit_behavior = "Close"
    config.close_on_exit = false
    return config
  '';
}
