{pkgs}:

let
  mkShellPkg = name: src: pkgs.stdenvNoCC.mkDerivation {
    pname = name;
    version = "1.0.0";
    inherit src;
    
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${name}
      chmod +x $out/bin/${name}
    '';
  };
in {
  # 쉘 스크립트를 개별적으로 정의
  commit = mkShellPkg "commit" ./commit.sh;
  
  # 추가적인 쉘 스크립트가 있다면 여기에 추가
  # example = mkShellPkg "example" ./example.sh;
}
