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
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingKey = "~/.ssh/id_ed25519";
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
}
