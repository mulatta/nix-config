{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./1password.nix
    ./taskwarrior.nix
    ./n8n.nix
    ./claude-code.nix
    ./bitwarden.nix
  ];
}
