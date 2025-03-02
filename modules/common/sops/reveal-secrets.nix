{ config, lib, pkgs, ... }:

let
  hostName = config.networking.hostName or (builtins.getEnv "HOSTNAME");
  defaultSopsDir = "${config.home.homeDirectory}/nix-secrets/sops";
in
{
  sops = {
    # 기본 AGE 키 위치
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # 기본 sops 파일 설정 - 호스트별 파일이 없으면 shared 사용
    defaultSopsFile =
      if builtins.pathExists "${defaultSopsDir}/hosts/${hostName}.yaml"
      then "${defaultSopsDir}/hosts/${hostName}.yaml"
      else "${defaultSopsDir}/hosts/shared.yaml";

    # 비밀 정의
    secrets = {
      # GitHub 토큰
      "github/personal_token" = {
        path = "${config.xdg.configHome}/github/token";
        mode = "0400";
        sopsFile = "${defaultSopsDir}/github/token.yaml";
      };

      # Git 서명용 SSH 키 (GitHub 등)
      "ssh/github_key" = {
        path = "${config.home.homeDirectory}/.ssh/github_ed25519";
        mode = "0400";
        sopsFile = "${defaultSopsDir}/ssh/keys.yaml";
      };

      # Git 서명용 SSH 공개키
      "ssh/github_key_pub" = {
        path = "${config.home.homeDirectory}/.ssh/github_ed25519.pub";
        mode = "0644";
        sopsFile = "${defaultSopsDir}/ssh/keys.yaml";
      };
    };
  };
}
