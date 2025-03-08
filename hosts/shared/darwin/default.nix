{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
  users.users.seungwon = {
    name = "seungwon";
    home = "/Users/seungwon";
    shell = pkgs.zsh;
  };
  imports = [
    ./system.nix
    ./security.nix
    ./system-pkgs.nix
    ./homebrew.nix
  ];
}
