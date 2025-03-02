{ config, lib, ... }:
{
  imports = [
    ./helix
    ./starship
    ./wezterm
    ./direnv.nix
    ./yazi
    ./bat.nix
    ./eza.nix
    ./fd.nix
    ./fonts.nix
    ./fzf.nix
    ./gh.nix
    ./git
    ./python.nix
    ./ripgrep.nix
    ./zellij.nix
    ./zoxide.nix
    ./zsh.nix
  ];
}
