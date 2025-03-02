{ config, pkgs, lib, ... }:
{
  security.sudo.extraRules = [
    {
      users = [ "seungwon" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = "/home/mulatta/nix-secrets/sops/hosts/mulatta.yaml";

  };
}
