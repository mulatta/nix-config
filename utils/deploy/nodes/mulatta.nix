{
  outputs,
  lib,
  ...
}: {
  hostname = "100.70.147.90";
  # hostname = "mulatta.local";

  # 프로필 정의
  profiles = {
    # 시스템 프로필
    system =
      lib.mkSystemProfile
      outputs.nixosConfigurations.mulatta
      "x86_64-linux";

    # 홈 매니저 프로필
    home-seungwon =
      lib.mkHomeProfile
      outputs.homeConfigurations."seungwon@mulatta"
      "seungwon"
      "x86_64-linux"
      "/home/seungwon/.local/state/nix/profiles/home-manager";
  };

  # 배포 순서
  profilesOrder = ["system" "home-seungwon"];

  # mulatta 특화 설정
  # 만약 mulatta가 강력한 서버라면:
  # remoteBuild = true;
  # fastConnection = true;

  # 만약 mulatta가 원격 서버라면:
  # sshOpts = [ "-p" "2222" "-i" "~/.ssh/mulatta_key" ];

  # 개발 서버라면 롤백 비활성화도 고려:
  # autoRollback = false;
}
