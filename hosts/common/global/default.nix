# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./fish.nix
      ./locale.nix
      ./nix.nix
      ./ssh.nix
      ./optin-persistence.nix
      ./podman.nix
      ./sops.nix
      ./tailscale.nix
      ./nix-ld.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
  documentation.man.enable = false;

  # hardware.enableRedistributableFirmware = true;
  # networking.domain = "m7.rs";
}
