{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
}:
stdenvNoCC.mkDerivation {
  pname = "keymapp";
  version = "1.3.4";

  src = fetchurl {
    url = "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.dmg";
    sha256 = "0g2jjibn62xsija0zvfanga4vm4q16kn0jnbf43yllkrkyqsh7my";
  };

  nativeBuildInputs = [undmg];
  sourceRoot = ".";

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    runHook preUnpack
    undmg $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r keymapp.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://zsa.io/flash";
    description = "ZSA keyboard firmware flasher";
    license = licenses.unfree;
    platforms = platforms.darwin;
    maintainers = [maintainers.mulatta];
  };
}
