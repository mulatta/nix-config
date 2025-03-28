# overlay/bin-scripts.nix
final: prev:
let
  binScripts = import ../bins/bin-packages.nix { pkgs = prev; };
in
{
  # Export all scripts as a single attribute set
  binScripts = binScripts;

  # Also make individual scripts available at the top level
  inherit (binScripts) commit;
  
  # If you add more scripts, you can expose them here
  # inherit (binScripts) commit script2 script3;
}
