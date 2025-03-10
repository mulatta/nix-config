{ config, pkgs, ... }:
{
  imports = [
    ./system.nix
    ./security.nix
    ./system-pkgs.nix
    ./homebrew.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;
  users.users.seungwon = {
    name = "seungwon";
    home = "/Users/seungwon";
    shell = pkgs.nushell;
  };
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "root" "seungwon" ];
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
