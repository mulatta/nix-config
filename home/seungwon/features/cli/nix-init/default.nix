{pkgs, ...}: {
  programs.nix-init = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
}
