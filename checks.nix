{
  inputs,
  pkgs,
  ...
}: {
  pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
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
}
