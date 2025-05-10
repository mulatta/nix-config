{pkgs, ...}: {
  imports = [
    ./cmatrix.nix
    ./colima.nix
    ./docker.nix
    ./mdbook.nix
    ./ollama.nix
    ./typst.nix
  ];
}
