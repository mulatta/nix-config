{ stdenv, ... }:
stdenv.mkDerivation {
  name = "bins";
  version = "unstable";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';
}
