{pkgs, ...}: {
  imports = [
    ./atuin
    ./bat.nix
    ./charm.nix
    ./direnv.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./gh
    ./git
    ./glow.nix
    ./gnused.nix
    ./ssh
    ./gpg
    ./grep.nix
    ./jujutsu.nix
    ./nh.nix
    ./nurl.nix
    ./nix-init
    ./postgre.nix
    ./starship
    ./yazi
    ./zoxide.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    ruff
    ripgrep
    marksman

    csvlens

    nixd # Nix LSP
    alejandra # Nix formatter
    nixfmt-rfc-style
    nvd # Differ
    nix-diff # Differ, more detailed
    nix-output-monitor
    nh # Nice wrapper for NixOS and HM
  ];
}
