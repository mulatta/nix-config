{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
    extraPackages = import ./helix-packages.nix { inherit pkgs; };
    languages = import ./languages.nix { inherit pkgs; };
    defaultEditor = true;
  };
}
