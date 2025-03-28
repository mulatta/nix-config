{pkgs ? import <nixpkgs> {}}:

{
  packages = import ./bin-packages.nix {inherit pkgs;};
}
