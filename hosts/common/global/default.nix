# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  lib,
  ...
}: let
  inherit (inputs.nixpkgs.stdenv) isDarwin isLinux;
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      # import global configurations
      # ./fish.nix
      # ./locale.nix
      # ./nix.nix
      # ./openssh.nix
      # ./optin-persistence.nix
      # ./podman.nix
      # ./sops.nix
      # ./ssh-serve-store.nix
      # ./systemd-initrd.nix
      # ./tailscale.nix
      # ./nix-ld.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules)
    ++ lib.optional isDarwin inputs.home-manager.darwinModules.home-manager
    ++ lib.optional isLinux inputs.home-manager.nixosModules.home-manager;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  # hardware.enableRedistributableFirmware = true;
  # networking.domain = "m7.rs";
}
