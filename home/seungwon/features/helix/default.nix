{pkgs, ...}: {
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
    languages = import ./languages.nix {inherit pkgs;};
    defaultEditor = true;
  };
}
