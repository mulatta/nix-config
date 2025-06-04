{
  config,
  pkgs,
  ...
}: {
  environment = {
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
    systemPackages = with pkgs; [
      mkalias
      tree

      # python
      python312Full
      python312Packages.pyls-isort
      python312Packages.python-lsp-black
      python312Packages.python-lsp-server
      pylint
      uv

      # Apple SDK
      apple-sdk

      # nodejs
      nodejs_24

      # Custom User-defined scripts for utility
      # custom-scripts
    ];

    shells = with pkgs; [
      bash
      zsh
    ];
  };
}
