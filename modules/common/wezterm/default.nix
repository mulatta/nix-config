{ pkgs, ... }:

{
  # home.packages = with pkgs; [ wezterm ];
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  xdg.configFile = {
    "wezterm" = {
      source = ./dotfiles;
      recursive = true;
    };
  };
}
