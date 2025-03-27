{ config, pkgs, ... }:
{
  imports = [
    ./environment.nix
    ./homebrew.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./system-pkgs.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
  users.users.seungwon = {
    name = "seungwon";
    home = "/Users/seungwon";
    shell = pkgs.zsh;
  };
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "root"
        "seungwon"
      ];
    };
    optimise = {
      automatic = true;
      interval = {
        Weekday = 1;
        Hour = 13;
      };
    };
    gc = {
      automatic = true;
      interval = {
        Weekday = 1;
        Hour = 13;
      };
      options = "--delete-older-than 14d";
    };
  };
}
