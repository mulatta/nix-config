{ pkgs, ... }: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.d2coding
  ];
  fonts.fontconfig.enable = true;
}
