{inputs, ...}: let
  inherit (inputs) deploy-rs;
in {
  # home-manager activation helper
  mkHomeManagerActivation = homeConfig: system: let
    hmActivation = homeConfig.activationPackage;
  in
    deploy-rs.lib.${system}.activate.custom hmActivation "./activate";

  # NixOS system activation helper
  mkNixOSActivation = nixosConfig: system:
    deploy-rs.lib.${system}.activate.nixos nixosConfig;

  # custom service activation helper
  mkCustomActivation = package: script: system:
    deploy-rs.lib.${system}.activate.custom package script;

  # common profile generater helper
  mkSystemProfile = nixosConfig: system: {
    user = "root";
    path = deploy-rs.lib.${system}.activate.nixos nixosConfig;
  };

  mkHomeProfile = homeConfig: user: system: profilePath: {
    inherit user;
    path =
      deploy-rs.lib.${system}.activate.custom
      homeConfig.activationPackage "./activate";
    profilePath = profilePath;
  };
}
