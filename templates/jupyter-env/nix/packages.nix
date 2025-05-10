{
  inputs,
  pkgs,
}: let
  inherit (inputs) uv2nix;
  workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ../.;};
  jupyterEnv = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel";
  };
in {
  jupyterEnv = jupyterEnv;
}
