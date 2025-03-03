{ inputs, pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib.lists) optionals;
  sharedPkgs = import ./shared/home-pkgs.nix { inherit pkgs; };
  darwinPkgs = import ./darwin/home-pkgs.nix { inherit pkgs; };
  nixosPkgs = import ./nixos/home-pkgs.nix { inherit pkgs; };
in
{
  home-manager = {
    # home-manager base config
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm";
    extraSpecialArgs = { inherit inputs; };

    # home-manager user-packages
    users.mulatta = {
      # home-manager user config
      home.username = "mulatta";
      home.stateVersion = "25.05";

      # programs (manage configs & pkgs)
      imports = [
        ../../modules/common
        ../../modules/nixos/wayland.nix
        ./nixos/wezterm.nix
        inputs.nix-index-database.hmModules.nix-index
      ];

      # home-manager base modules enable
      programs.home-manager.enable = true;
      programs.nix-index.enable = true;

      # home-manager system packages
      home.packages = sharedPkgs
        ++ (optionals isDarwin darwinPkgs)
        ++ (optionals isLinux nixosPkgs);
    };
  };
}


