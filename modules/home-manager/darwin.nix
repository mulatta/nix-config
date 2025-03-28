{ inputs, pkgs, ... }:
{
  imports = [ ./common.nix ];

  # Darwin 특화 설정
  home-manager.users.seungwon = {
    imports = [ ../darwin ];
  };
}
