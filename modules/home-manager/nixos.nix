{ inputs, pkgs, ... }:
{
  imports = [ ./common.nix ];

  # NixOS 특화 설정
  home-manager.users.seungwon = {
    imports = [ ../nixos ];
  };
}
