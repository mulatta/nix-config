{ config, lib, ... }:
{
  imports = [
    ./1password.nix
    ./bat.nix
    ./charm.nix
    ./claude-code.nix
    ./direnv.nix
    ./editorconfig.nix
    ./eza.nix
    ./fd.nix
    ./fonts.nix
    ./fzf.nix
    ./mdbook.nix
    ./gh
    # ./ghostty
    ./git
    ./glow.nix
    ./gpg
    ./gnused.nix
    ./grep.nix
    ./helix
    ./languages
    ./nurl.nix
    ./obsidian.nix
    ./ripgrep.nix
    ./sioyek.nix
    ./sops
    ./starship
    ./taskwarrior.nix
    ./wezterm
    ./yazi
    ./zoxide.nix
    ./zsh.nix
  ];
}
