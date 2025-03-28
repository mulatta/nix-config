{
  overlays,
  nixpkgs,
  inputs,
}:
{
  system,
  hostname,
}:
let
  # NixOS 시스템 빌더
  systemBuilder = nixpkgs.lib.nixosSystem;

  # 호스트별 구성 모듈
  hostModule = ../hosts/${hostname};
in
systemBuilder {
  inherit system;
  specialArgs = {
    inherit inputs;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlays ];
      config = {
        allowUnfree = true;
      };
    };
  };

  # VM 생성과 호환되는 모듈만 포함
  modules = [
    # VM 테스트 모듈 활성화
    (
      { lib, ... }:
      {
        # VM에서는 home-manager 비활성화
        disabledModules = [
          "home-manager/nixos.nix"
        ];

        # home-manager 관련 옵션 무시
        options.home-manager.users = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule { });
          default = { };
        };
      }
    )

    # 호스트 모듈 로드
    hostModule
  ];
}
