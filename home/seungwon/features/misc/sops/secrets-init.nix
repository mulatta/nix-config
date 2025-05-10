{
  config,
  lib,
  pkgs,
  ...
}: let
  # 스크립트 경로
  opUnlockScript = "${config.home.homeDirectory}/.local/bin/op-unlock-keys";
in {
  # systemd 사용자 서비스 설정 (Linux)
  systemd.user.services = lib.mkIf pkgs.stdenv.isLinux {
    op-unlock-keys = {
      Unit = {
        Description = "1Password에서 키 가져오기";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = opUnlockScript;
        Restart = "no";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };

  # launchd 서비스 설정 (macOS)
  launchd.user.agents = lib.mkIf pkgs.stdenv.isDarwin {
    op-unlock-keys = {
      serviceConfig = {
        Label = "op.unlock.keys";
        ProgramArguments = ["${pkgs.bash}/bin/bash" "-c" opUnlockScript];
        RunAtLoad = true;
        StandardOutPath = "/tmp/op-unlock-keys.log";
        StandardErrorPath = "/tmp/op-unlock-keys.error.log";
      };
    };
  };
}
