{ lib, fetchurl, stdenvNoCC, undmg }:

stdenvNoCC.mkDerivation {
  pname = "Hookmark";
  version = "6.7";

  src = fetchurl {
    url = "https://hookproductivity.com/downloads/Hookmark-app-6.7.dmg";
    sha256 = "dddc46b26d35cc473613dd14bce697ad32cb9014216784e57f72066c934b60ab";
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    ];
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    runHook preUnpack
    undmg $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Hookmark.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://hookproductivity.com";
    description = "Link and retrieve key information";
    license = licenses.unfree;
    platforms = platforms.darwin;
    maintainers = [ maintainers.mulatta ];
  };
}
