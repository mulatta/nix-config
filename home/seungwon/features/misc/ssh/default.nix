{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
  socketPath =
    if isDarwin
    then "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else if isLinux
    then ""
    else throw "System Not Supported.";
in {
  programs.ssh = {
    enable = true;
    # TODO: Use socket(1password) only with github & master
    matchBlocks = {
      "*" = {
        identityAgent = socketPath;
        extraOptions = {
          IgnoreUnknown = "UseKeyChain";
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
      };
      "my-server" = {
        hostname = "100.115.94.1";
        user = "mulatta";
        identityFile = [
          "~/.ssh/eq12_ed25519"
          "~/.ssh/id_ed25519"
        ];
        identitiesOnly = true;
        forwardAgent = false;
      };
      "github.com" = {
        identityFile = "~/.ssh/github_ed25519";
        identitiesOnly = true;
        forwardAgent = false;
        extraOptions = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/github.sock";
          ControlPersist = "5m";
        };
      };
    };
  };
}
