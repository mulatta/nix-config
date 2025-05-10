{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  environment.systemPackages = with pkgs; [
    age
    age-plugin-yubikey
    ssh-to-age
    sops
  ];

  sops = {
    age = {
      keyFile = "$HOME/Library/Application Support/sops/age/keys.txt";
    };
  };
}
