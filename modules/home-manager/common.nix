{ inputs, pkgs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";

  home-manager.users.seungwon = {
    imports = [
      ../common
      ../home.nix
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
