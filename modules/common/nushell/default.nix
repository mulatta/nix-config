{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    pkgs = pkgs.nushell;
  };
}
