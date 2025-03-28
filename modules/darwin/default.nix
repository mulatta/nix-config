{ ... }:
{
  # entry point of darwin packages
  imports = [
    # ./aldente.nix
    # ./bookends.nix
    # ./cleanshot.nix
    # ./homerow.nix
    # ./hookmark.nix
    # ./keycastr.nix
    # ./raycast.nix
    # ./slack.nix
    # ./karabiner-elements.nix
  ];

  home.homeDirectory = "/Users/seungwon";

  # never index the developer folder in spotlight.
  home.file."Developer/.metadata_never_index".text = "";

  # exclude GOPATH from time machine backups
  # exclude 'dist' and 'node_modules' folders as well
  # home.activation.time-machine-exclusions = ''
  #   /usr/bin/tmutil addexclusion /Users/carlos/Developer/Go/
  #   /usr/bin/tmutil addexclusion /Users/carlos/.cargo/
  #   /usr/bin/tmutil addexclusion /Users/carlos/.rustup/
  #   find /Users/carlos/Developer -maxdepth 3 \( -name 'dist' -or -name 'node_modules' -or -name 'target' -or -name 'zig-out' \) -not -path "*/Go/*" -not -path "*/.git/*" | while read -r p; do
  #     echo "TimeMachine: excluding $p..."
  #     /usr/bin/tmutil addexclusion "$p"
  #   done
  # '';
}
