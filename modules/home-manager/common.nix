{ inputs, pkgs, ... }:
{
  # 공통 설정 - 모든 시스템에 공통으로 적용할 설정
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";

  # 사용자 설정 - username은 모든 시스템에서 동일하게 사용
  home-manager.users.seungwon = {
    imports = [
      ../common
      ../home.nix
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
}
