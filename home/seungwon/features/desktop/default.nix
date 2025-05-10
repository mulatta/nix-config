{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./cursor.nix
    ./drawdb.nix
    ./drawio.nix
    ./firefox
    ./ghostty
    ./obsidian.nix
    ./wezterm
    ./windsurf
    ./zed
  ];
}
