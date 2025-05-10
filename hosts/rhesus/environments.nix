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

      # securities
      rage
      yubikey-manager
      pam_u2f

      # Custom User-defined scripts for utility
      # custom-scripts

      # Utilities
      ollama
    ];

    shells = with pkgs; [
      bash
      zsh
    ];
  };

  # launchd = {
  #   user = {
  #     agents = {
  #       ollama-serve = {
  #         serviceConfig = {
  #           Label = "com.ollama.serve";
  #           ProgramArguments = ["${pkgs.ollama}/bin/ollama " "serve"];
  #           KeepAlive = true;
  #           RunAtLoad = true;
  #           StandardOutPath = "/tmp/ollama.out.log";
  #           StandardErrorPath = "/tmp/ollama.err.log";
  #         };
  #       };
  #     };
  #   };
  # };
}
