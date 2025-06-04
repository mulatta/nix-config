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

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../../../home/seungwon/keys/ssh_id_ed25519_sk.pub)
      (builtins.readFile ../../../../home/seungwon/keys/ssh_backup_id_ed25519_sk.pub)
    ];
    # hashedPasswordFile = config.sops.secrets.seungwon-password.path;
    initialPassword = "nixos-temp";
    packages = [pkgs.home-manager];
  };

  # sops.secrets.seungwon-password = {
  #   sopsFile = ../../secrets.yaml;
  #   neededForUsers = true;
  # };

  home-manager.users.seungwon = import ../../../../home/seungwon/${config.networking.hostName}.nix;
}
