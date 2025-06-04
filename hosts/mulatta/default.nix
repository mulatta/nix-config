{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./networking.nix

    ../common/global
    ../common/users/seungwon
    ../common/optional/ephemeral-btrfs.nix

    ./services
  ];

  environment.systemPackages = with pkgs; [];

  system.stateVersion = "24.11";
}
