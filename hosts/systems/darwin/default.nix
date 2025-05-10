{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fish.nix
    ./sops.nix
  ];
}
