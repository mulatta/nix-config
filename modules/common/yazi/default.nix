{ pkgs, config, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    package = pkgs.yazi;
    settings = import ./settings.nix;
    keymap = import ./keymap.nix;
    theme = import ./theme.nix;
    flavors = import ./flavors.nix { inherit pkgs; };
    plugins = import ./plugins.nix { inherit pkgs; };
    shellWrapperName = "y";
  };
}
