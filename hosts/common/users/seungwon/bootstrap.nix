# Bootstrap User Configuration for nixos-anywhere
# This configuration provides temporary access during initial installation
{
  pkgs,
  lib,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.seungwon = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "video"
      "docker"
      "git"
      "network"
      "podman"
      "wheel"
    ];

    # During bootstrap, use a temporary password for initial access
    # YubiKey-based SSH keys will be activated after initial setup
    openssh.authorizedKeys.keys = [
      # Add your regular SSH key here as fallback during bootstrap
      # This can be a standard key without YubiKey requirement
      (builtins.readFile ../../../../home/seungwon/keys/ssh_id_ed25519_sk.pub)
      (builtins.readFile ../../../../home/seungwon/keys/ssh_backup_id_ed25519_sk.pub)
    ];

    # Temporary password for initial access - change this after bootstrap
    initialPassword = "nixos-temp-bootstrap";
    packages = [pkgs.home-manager];
  };

  # Enable SSH during bootstrap
  services.openssh = {
    enable = true;
    settings = {
      # Temporarily allow password authentication during bootstrap
      PasswordAuthentication = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "yes";
    };
  };

  # Note: After bootstrap, switch to SOPS-managed password
  # sops.secrets.seungwon-password = {
  #   sopsFile = ../../secrets.yaml;
  #   neededForUsers = true;
  # };
  # Then update user config to:
  # hashedPasswordFile = config.sops.secrets.seungwon-password.path;

  home-manager.users.seungwon = import ../../../../home/seungwon/${config.networking.hostName}.nix;
}
