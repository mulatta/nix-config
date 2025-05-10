{pkgs ? import <nixpkgs> {}, ...}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      rustc
      cargo
      gcc
      rustfmt
      clippy
    ];
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}
