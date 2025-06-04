{
  inputs,
  outputs,
  lib,
  ...
}: let
  deployLib = import ./lib.nix {inherit inputs lib;};
  globals = import ./globals.nix;

  nodes = {
    mulatta = import ./nodes/mulatta.nix {
      inherit outputs;
      lib = lib // deployLib;
    };

    # EXAMPLES: Additional Nodes
    # web-server = import ./nodes/web-server.nix {
    #   inherit outputs;
    #   lib = lib // deployLib;
    # };
  };
in
  globals
  // {
    inherit nodes;
  }
