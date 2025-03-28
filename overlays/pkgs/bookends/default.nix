{ lib, fetchurl, stdenvNoCC, darwin }:

stdenvNoCC.mkDerivation {
  pname = "bookends";
  version = "15.1.2";

  src = fetchurl {
    url = "https://www.sonnysoftware.com/bookends-for-mac/downloads/Bookends.dmg";
    sha256 = "14abaxjc80pgcmm6l0j49yix59vx9z4lczh2mimk068agp74nqdw";
  };

  buildInputs = lib.optionals stdenvNoCC.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.DiskArbitration
  ];

  unpackPhase = ''
    runHook preUnpack
    
    hdutil_path=$(type -p hdiutil || echo /usr/bin/hdiutil)
    volname=$(echo -n "$src" | ${stdenvNoCC.shell} -c 'xargs basename' | sed -e 's/\.dmg$//')
    mountpoint=$(mktemp -d)
    
    echo "Mounting DMG to $mountpoint..."
    "$hdutil_path" attach -nobrowse -readonly -mountpoint "$mountpoint" "$src"
    
    echo "Copying contents..."
    cp -r "$mountpoint/"* .
    
    echo "Unmounting..."
    "$hdutil_path" detach "$mountpoint"
    
    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -R "Bookends.app" "$out/Applications/"
  '';

  meta = with lib; {
    homepage = "https://www.sonysoftware.com/bookends-for-mac";
    description = "Reference management and bibliography software";
    license = licenses.unfree;
    platforms = platforms.darwin;
    maintainers = [ maintainers.mulatta ];
  };
}
