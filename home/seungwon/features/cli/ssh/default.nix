{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;
    # TODO: Use socket(1password) only with github & master
    matchBlocks = {
      # "*" = {
      #   identityAgent = socketPath;
      #   extraOptions = {
      #     IgnoreUnknown = "UseKeyChain";
      #     UseKeychain = "yes";
      #     AddKeysToAgent = "yes";
      #   };
      # };
      "mulatta" = {
        hostname = "100.112.255.102";
        user = "seungwon";
        identityFile = [
          "~/.ssh/id_ed25519_sk"
        ];
        identitiesOnly = true;
        forwardAgent = false;
      };

      # vm on mac
      "nix-builder" = {
        hostname = "127.0.0.1";
        port = 55801;
        user = "seungwon";
        identityFile = "/Users/seungwon/.colima/_lima/_config/user";
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
          NoHostAuthenticationForLocalhost = "yes";
          PreferredAuthentications = "publickey";
          Compression = "no";
          BatchMode = "yes";
          IdentitiesOnly = "yes";
          Ciphers = "^aes128-gcm@openssh.com,aes256-gcm@openssh.com";
          ControlMaster = "auto";
          ControlPath = "/Users/seungwon/.colima/_lima/colima-nix-builder/ssh.sock";
          ControlPersist = "yes";
        };
      };

      # github ssh with yubikey
      "github.com" = {
        identityFile = "~/.ssh/github_id_ed25519_sk";
        identitiesOnly = true;
        forwardAgent = false;
        extraOptions = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/github.sock";
          ControlPersist = "5m";
        };
      };
    };
  };

  home.packages = with pkgs; [
    openssh
    gnupg
    pinentry-curses
    sops
    rage
    ssh-to-age
    paperkey
    yubikey-personalization
    age-plugin-yubikey
    libfido2
    pam_u2f
    yubico-piv-tool
  ];
}
