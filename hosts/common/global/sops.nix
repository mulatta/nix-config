{
  inputs,
  config,
  pkgs,
  ...
}: let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  environment.systemPackages = with pkgs; [
    age
    age-plugin-yubikey
    ssh-to-age
    sops
  ];
  sops = {
    age.sshKeyPaths = map getKeyPath keys;
  };
}
