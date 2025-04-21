{ pkgs, ... }:
{
  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    systemPackages = with pkgs; [
      mkalias
      tree

      # python dev-envs
      python312Packages.python-lsp-server
      python312Packages.python-lsp-black
      python312Packages.pyls-isort
      python312Packages.pylsp-mypy
      uv
      black
      mypy
      pylint

      # Apple SDK
      darwin.apple_sdk.frameworks.OpenGL
      darwin.apple_sdk.frameworks.Cocoa
    ];

    shells = with pkgs; [
      bash
      zsh
    ];
  };
}
