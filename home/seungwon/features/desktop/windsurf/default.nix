{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.windsurf
  ];
}
