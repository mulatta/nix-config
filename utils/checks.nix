{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs) pre-commit-hooks deploy-rs;

  pre-commit-check = pre-commit-hooks.lib.${pkgs.system}.run {
    src = ./.;
    hooks = {
      sops-encryption = {
        enable = true;
        name = "sops-encryption";
        entry = "${pkgs.pre-commit-hook-ensure-sops}/bin/pre-commit-hook-ensure-sops";
        language = "system";
        files = "secrets.*\\.ya?ml$";
        pass_filenames = true;
      };
      alejandra.enable = true;
    };
  };

  deploy-checks =
    if outputs ? deploy
    then deploy-rs.lib.${pkgs.system}.deployChecks outputs.deploy
    else {};
in
  deploy-checks
  // {
    pre-commit-check = pre-commit-check;
  }
