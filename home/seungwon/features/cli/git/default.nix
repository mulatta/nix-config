{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;

  # For key rotation
  user = {
    name = "mulatta";
    mail = "67085791+mulatta@users.noreply.github.com";
    key = builtins.readFile ./ssh_github_ed25519_key.pub;
  };

  # extra-config
  extraCfg = import ./extra-config.nix {inherit config;};

  # For OS specific directory
  darwinSinger = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  nixosSigner = "";
in {
  home.packages = with pkgs; [
    git-lfs
  ];
  home.file.".ssh/allowed_signers".text = "${user.mail} ${user.key}";

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.mail;
    delta.enable = true;
    lfs.enable = true;

    signing = {
      key = user.key;
      signByDefault = true;
      signer =
        if isDarwin
        then darwinSinger
        else nixosSigner;
      format = "ssh";
    };

    # extraConfig = import ./extra-config.nix;
    extraConfig = extraCfg;
    # extraConfig = {
    #   init.defaultBranch = "main";
    #   gpg = {
    #     program = "${config.programs.gpg.package}/bin/gpg2";
    #     ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    #   };

    #   mergeConflictStyle = "zdiff3";
    #   commit.verbose = true;
    #   diff.algorithm = "histogram";
    #   log.date = "iso";
    #   branch.sort = "committerdate";
    #   rerere.enabled = true;

    #   core = {
    #     editor = "hx";
    #     compression = -1;
    #     autocrlf = "input";
    #     whitespace = "trailing-space,space-before-tab";
    #     precomposeunicode = true;
    #   };

    #   color = {
    #     diff = "auto";
    #     status = "auto";
    #     branch = "auto";
    #     ui = true;
    #   };

    #   push = {
    #     autoSetupRemote = true;
    #     default = "simple";
    #   };

    #   pull = {
    #     ff = "only";
    #   };

    #   url = {
    #     "git@github.com:".insteadOf = "https://github.com/";
    #   };
    # };

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
      inactiveBorderColor = ["black"];
      selectedLineBgColor = ["default"];
    };
  };
}
