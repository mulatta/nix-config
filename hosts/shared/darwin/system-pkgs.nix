{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_23
    
    # 사용자 정의 스크립트
    commit
    # 추가 스크립트가 있다면 여기에 추가
  ];
}
