{ pkgs }:

let
  mkShellPkg =
    name: scriptPath:
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = "1.0.0";

      src = ./.;

      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/bin
        cp $src/${scriptPath} $out/bin/${name}
        chmod +x $out/bin/${name}
      '';
    };
in
{
  # 쉘 스크립트를 개별적으로 정의
  commit = mkShellPkg "gcm" "commit.sh";

  # 추가적인 쉘 스크립트가 있다면 여기에 추가
  # example = mkShellPkg "example" "example.sh";
}
