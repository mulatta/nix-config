{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.git-lfs ];
  # home.file.".ssh/allowed_signers".text =

  programs.git = {
    enable = true;
    userName = "mulatta";
    userEmail = "lsw1167@gmail.com";
    delta.enable = true;
    lfs.enable = true;
    extraConfig = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFirle = "~/.ssh/allowed_signers";
      user.signingKey = "~/.ssh/id_ed25519";
    };
    ignores = [
      ".DS_store"
      "*pam"
    ];
  };
}
