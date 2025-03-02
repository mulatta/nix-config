{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = import ./settings.nix;
    # packages = import ./package.nix;
    keymap = import ./keymap.nix;
    theme = import ./theme.nix;
    flavors = import ./flavors.nix { inherit pkgs; };
    plugins = import ./plugins.nix { inherit pkgs; };
    shellWrapperName = "y";
  };

  # # dotfiles
  # xdg.configFile = {
  #   # plugins
  #   "yazi" = {
  #     source = ./dotfiles;
  #     recursive = true;
  #   };
  # };
}
