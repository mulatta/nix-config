{ lib, fetchurl, stdenvNoCC, darwin }:

stdenvNoCC.mkDerivation rec {
  pname = "cleanshot";
  version = "4.7.6";

  src = fetchurl {
    url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
    sha256 = "0mbv61rqm8hqgwqal1qxbf1rqr5rqa94flsskmbksphc0sw7hwb7";
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
    cp -R "CleanShot X.app" "$out/Applications/"
  '';

  meta = with lib; {
    homepage = "https://cleanshot.com/";
    description = "Screen capturing tool";
    license = licenses.unfree;
    platforms = platforms.darwin;
    maintainers = [ maintainers.mulatta ];
  };
}
