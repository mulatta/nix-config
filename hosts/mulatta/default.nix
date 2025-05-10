{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./networking.nix

    ../systems/nixos/global
    ../systems/nixos/users/seungwon

    # ../systems/nixos/optional/greetd.nix
    # ../systems/nixos/optional/quietboot.nix
    # ../systems/nixos/optional/wireless.nix
    # ../systems/nixos/optional/encrypted-root.nix
    ../systems/nixos/optional/ephemeral-btrfs.nix

    ./services
  ];

  environment.systemPackages = with pkgs; [];

  # ======== Networking ========

  system.stateVersion = "24.11";
}
