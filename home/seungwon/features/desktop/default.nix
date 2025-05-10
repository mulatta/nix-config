{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./cursor.nix
    ./drawdb.nix
    ./drawio.nix
    ./ghostty
    ./obsidian.nix
    ./wezterm
  ];
}
