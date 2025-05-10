{lib, ...}: {
  imports = [
    ./system/nixos.nix
    ./features/productivity
    ./features/utils
  ];
  home = {
    username = "seungwon";
    homeDirectory = "/home/seungwon";
    stateVersion = "25.05";

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      PROJECTS = "$HOME/Developer";
    };

    # ensures ~/Developer folder exists.
    activation.developer = ''
      mkdir -p ~/Developer
    '';

    file."Developer/.metadata_never_index".text = "";
  };
}
