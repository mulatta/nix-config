{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./packages.nix];
  users.mutableUsers = false;
  users.users.mulatta = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keyFiles = ./default.nix;
    hashedPasswordFile = config.sops.secrets.macaca-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.mulatta-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.mulatta = import ../../../../home/seungwon/${config.networking.hostName}.nix;

  environment.persistence = {
    "/persist".directories = ["/home/mulatta"];
  };
}
