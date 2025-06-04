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
    ./fish.nix
    ./sops.nix
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
    shell = pkgs.fish;
  };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     set -g original_path $PATH
  #     function __fix_path_on_initialization --on-variable PATH
  #       if status --is-login
  #         set -g PATH $original_path
  #       end
  #     end
  #   '';
  # };

  system.primaryUser = "seungwon";

  # nix configurations
  nix = {
    package = pkgs.nix;
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "seungwon"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;
      flake-registry = ""; # Disable global flake registry
    };
    optimise = {
      automatic = true;
      interval = {
        Weekday = 1;
        Hour = 13;
      };
    };
    buildMachines = [
      {
        hostName = "nix-builder";
        sshUser = "seungwon";
        sshKey = "/Users/seungwon/.colima/_lima/_config/user";
        systems = ["x86_64-linux"];
        maxJobs = 4;
        speedFactor = 1;
        protocol = "ssh-ng";
        supportedFeatures = ["nixos-test" "big-parallel" "benchmark"];
        mandatoryFeatures = [];
      }
    ];
  };
}
