{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    black
    mypy
    pylint
    python312Packages.python-lsp-server
    python312Packages.python-lsp-black
    python312Packages.pyls-isort
    python312Packages.pylsp-mypy
  ];
}
