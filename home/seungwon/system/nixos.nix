{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [
      inputs.impermanence.homeManagerModules
      ../features/cli
      ../features/helix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "seungwon";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
    };

    persistence = {
      "/persist/${config.home.homeDirectory}" = {
        defaultDirectoryMethod = "symlink";
        directories = [
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          ".local/bin"
          ".local/share/nix" # trusted settings and repl history
        ];
        allowOther = true;
      };
    };
  };
}
