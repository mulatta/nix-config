# hosts/vm-test/default.nix

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # 기본 시스템 설정
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 네트워크 설정
  networking = {
    hostName = "vm-test";
    useDHCP = true;
    firewall.enable = false;
  };

  # 패키지
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  # 사용자 설정
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };

  # SSH 서버
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
  };

  # VM 테스트용 특수 설정
  virtualisation = {
    # VM 메모리 (기본값, QEMU_OPTS로 재정의 가능)
    memorySize = 4096;

    # 디스크 크기(MB)
    diskSize = 8192;

    # 가상 네트워크 설정
    vlans = [ 1 ];

    # 쓰기 가능한 Nix 저장소 (테스트용)
    writableStore = true;

    # QEMU 옵션
    qemu = {
      networkingOptions = [
        "-net nic,netdev=user.0,model=virtio"
        "-netdev user,id=user.0,hostfwd=tcp::2222-:22"
      ];
      options = [
        "-vga virtio"
      ];
    };
  };

  # 시스템 버전
  system.stateVersion = "24.05";
}
