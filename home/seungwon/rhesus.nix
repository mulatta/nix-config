{lib, ...}: {
  imports = [
    ./system/darwin.nix
    ./features/desktop
    ./features/productivity
    ./features/utils
  ];
  home = {
    username = "seungwon";
    homeDirectory = "/Users/seungwon";
    stateVersion = "25.05";

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      PROJECTS = "$HOME/Developer";
    };

    # ensures ~/Developer folder exists.
    # this folder is later assumed by other activations, specially on darwin.
    activation.developer = ''
      mkdir -p ~/Developer
    '';
  };
}
