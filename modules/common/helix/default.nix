{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    settings = import ./settings.nix;
    extraPackages = import ./helix-packages.nix { inherit pkgs; };
    languages = import ./languages.nix { inherit pkgs; };
    defaultEditor = true;
  };
}
