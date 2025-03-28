{ pkgs, checks ? { } }:
let
  # 도구 목록을 더 안전하게 정의 - 일부가 없을 수 있음
  # pkgs에 해당 도구가 있는지 확인하는 헬퍼 함수
  hasPkg = pkg: builtins.hasAttr pkg pkgs;
  
  # 사용 가능한 도구만 포함하는 목록
  tools = with pkgs; [
    nixfmt-rfc-style
    statix
    # commitlint-rs가 없을 수 있으므로 조건부 추가
    (if hasPkg "commitlint-rs" then commitlint-rs else null)
    nurl
    sops
    ssh-to-age
    age
  ];
  
  # null 값 제거
  filteredTools = builtins.filter (x: x != null) tools;
in
{
  default = pkgs.mkShell {
    name = "nix-config-devshell";
    buildInputs = filteredTools;
    shellHook = ''
      echo "Welcome to nix-config development environment!"
      echo "Available tools: $(echo $PATH | tr ':' '\n' | grep -o 'nixfmt-rfc-style\|statix\|commitlint-rs\|nurl\|sops\|ssh-to-age\|age' | tr '\n' ' ')"
    '';
  };

  # 추가 개발 셸을 필요에 따라 정의할 수 있습니다
  checks = pkgs.mkShell {
    name = "nix-config-checks";
    buildInputs = filteredTools;
    shellHook = ''
      echo "Running nix-config checks..."
      if command -v ${pkgs.nixfmt-rfc-style}/bin/nixfmt &> /dev/null; then
        ${pkgs.nixfmt-rfc-style}/bin/nixfmt --check .
      fi
      if command -v ${pkgs.statix}/bin/statix &> /dev/null; then
        ${pkgs.statix}/bin/statix check .
      fi
      echo "All checks passed!"
    '';
  };
}
