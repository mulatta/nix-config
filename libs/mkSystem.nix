{
  overlays,
  nixpkgs,
  inputs,
}:
{
  system,
  hostname,
  isDarwin ? false,
  extraModules ? [ ],
}:
let
  systemBuilder = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  baseModules =
    if isDarwin then
      [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.home-manager.darwinModules.home-manager
        ../modules/home-manager/darwin.nix
      ]
    else
      [
        inputs.home-manager.nixosModules.home-manager
        ../modules/home-manager/nixos.nix
      ];

  hostModule = ../hosts/${hostname};
in
systemBuilder {
  inherit system;
  specialArgs = {
    inherit inputs;
    # 중앙에서 정의된 pkgs를 사용하는 대신, inputs를 전달하고
    # 호스트 모듈에서 필요에 따라 pkgs를 참조하도록 함
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlays ]; # 중앙에서 정의된 overlays 사용
      config = {
        allowUnfree = true;
      };
    };
  };
  modules = baseModules ++ [ hostModule ];
}
