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
    keyPath = "${config.home.homeDirectory}/.ssh/github_id_ed25519_sk";
    pubKey = builtins.readFile ./github_id_ed25519_sk.pub;
  };

  # extra-config
  extraCfg = import ./extra-config.nix {inherit config;};
in {
  home.packages = with pkgs; [
    git-lfs
    gitoxide
  ];
  home.file.".ssh/allowed_signers".text = "${user.mail} ${user.pubKey}";

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.mail;
    delta.enable = true;
    lfs.enable = true;

    signing = {
      key = user.keyPath;
      signByDefault = true;
      signer = "${pkgs.openssh}/bin/ssh-keygen";
      format = "ssh";
    };

    extraConfig = extraCfg;

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
