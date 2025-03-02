{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;

  # For key rotation
  gitPubKey = builtins.readFile ../../../gitssh.pub;
  gitUserName = "mulatta";
  gitUserMail = "67085791+mulatta@users.noreply.github.com";

  # For OS specific directory
  darwinSinger = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  nixosSigner = "";

in
{
  home.packages = with pkgs; [
    git-lfs
  ];
  home.file.".ssh/allowed_signers".text = "${gitUserMail} ${gitPubKey}";

  programs.git = {
    enable = true;
    userName = gitUserName;
    userEmail = gitUserMail;
    delta.enable = true;
    lfs.enable = true;

    signing = {
      key = gitPubKey;
      signByDefault = true;
      signer = if isDarwin then darwinSinger else nixosSigner;
      format = "ssh";
    };

    extraConfig = {
      commit.gpgSign = true;
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
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

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      pull = {
        ff = "only";
      };

      init.defaultBranch = "main";

      url = {
        "git@github.com:".insteadOf = "https://github.com/";
      };
    };

    aliases = {
      co = "checkout";
      commit = "commit -s";
    };

    ignores = lib.splitString "\n" (builtins.readFile ./gitignore_global);
  };

  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
    settings = {
      lightTheme = false;
      activeBorderColor = [
        "blue"
        "bold"
      ];
      inactiveBorderColor = [ "black" ];
      selectedLineBgColor = [ "default" ];
    };
  };
}
