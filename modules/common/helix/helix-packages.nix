{ pkgs, ... }:
with pkgs; [
  # LSP servers
  python312Packages.python-lsp-server
  ruff
  rust-analyzer
  nil

  # Formatter
  black
  nixpkgs-fmt

  ripgrep

  # markdown
  marksman
]
