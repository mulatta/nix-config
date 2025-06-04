{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./1password.nix
    ./bitwarden.nix
    ./sops
    ./yubikey.nix
  ];
}
