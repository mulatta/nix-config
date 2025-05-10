{pkgs, ...}: {
  imports = [
    ./colima.nix
    ./typst.nix
    ./cmatrix.nix
    ./docker.nix
  ];
}
