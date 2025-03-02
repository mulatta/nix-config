{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.git-lfs ];
  # home.file.".ssh/allowed_signers".text =

  programs.git = {
    enable = true;
    userName = "mulatta";
    userEmail = "67085791+mulatta@users.noreply.github.com";
    delta.enable = true;
    lfs.enable = true;

    extraConfig = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = "~/.ssh/github_ed25519";
      core = {
        editor = "hx";
        compression = -1;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        precomposeunicode = true;
      };

      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
        ui = true;
      };

      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@gitlab.com:".insteadOf = "https://gitlab.com/";
      };
    };
    ignores = lib.splitString "\n" (builtins.readFile ./gitignore_global);
  };
  home.file."~/.ssh/allowed_signers".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUynAzS0n6J++Iee01R+uD2/zvVOI2l4IWgLSfg7lq2 github 67085791+mulatta@users.noreply.github.com";
}
