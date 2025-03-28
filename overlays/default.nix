# overlay/default.nix
{ inputs, ... }:

final: prev: {
  # Import NUR overlay
  nur = import inputs.nur {
    nurpkgs = prev;
    pkgs = prev;
    repoOverrides = {};
  };

  # Import bin-scripts overlay
  # This will add all custom scripts to nixpkgs
  # They will be available as pkgs.commit, pkgs.binScripts.commit etc.
  inherit (import ./bin-scripts.nix final prev) 
    binScripts
    commit;
    # Add more scripts here as you create them
}
