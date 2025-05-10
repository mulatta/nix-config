{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./1password.nix
    ./taskwarrior.nix
    ./claude-code.nix
    ./bitwarden.nix
  ];
}
