{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./environments.nix
    ./homebrew.nix
    ./security.nix
    ./system.nix
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  networking = {
    hostName = "rhesus";
  };

  # User configurations
  users.users.seungwon = {
    name = "seungwon";
    home = "/Users/seungwon";
    shell = pkgs.zsh;
  };

  # nix configurations
  nix = {
    package = pkgs.nix;
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
  };
}
