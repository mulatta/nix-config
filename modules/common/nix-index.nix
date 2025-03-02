{ pkgs, ... }:
{
  programs.command-not-found = {
    enable = true;
  };
  programs.bash.initExtra = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';
}
