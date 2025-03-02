{ config, pkgs, ... }:
{
  # User profile
  users.users.seungwon = {
    name = "seungwon";
    home = "/Users/seungwon";
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # System profile 
  environment.systemPackages = with pkgs; [
    # shell utilities
    mkalias
    tree

    # dev-tools
    uv
    docker

    # programming languages
    black
    mypy
    pylint
    python312Packages.python-lsp-server
    python312Packages.python-lsp-black
    python312Packages.pyls-isort
    python312Packages.pylsp-mypy
    # R
  ];
}
