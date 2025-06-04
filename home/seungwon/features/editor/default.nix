{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./editorconfig.nix
    ./fonts.nix
    ./helix
    ./mdbook.nix
    ./typst.nix
  ];
}
