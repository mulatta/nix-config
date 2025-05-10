{
  lib,
  fetchurl,
  stdenvNoCC,
  apple-sdk,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ghostty";
  version = "1.1.2";

  src = fetchurl {
    url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
    sha256 = "d4ad01396834ca447fa5d084ebf6fb5d44957280faaf22ea473e9606751c48e1";
  };

  buildInputs = lib.optionals stdenvNoCC.isDarwin [
    apple-sdk
  ];

  unpackPhase = ''
    runHook preUnpack

    hdutil_path=$(type -p hdiutil || echo /usr/bin/hdiutil)
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
    cp -R "Ghostty.app" "$out/Applications/"

    mkdir -p "$out/bin"
    ln -s "$out/Applications/Ghostty.app/Contents/MacOS/ghostty" "$out/bin/ghostty"

    mkdir -p "$out/etc/bash_completion.d"
    mkdir -p "$out/share/fish/vendor_completions.d"
    mkdir -p "$out/share/zsh/site-functions"
    cp "$out/Applications/Ghostty.app/Contents/Resources/bash-completion/completions/ghostty.bash" "$out/etc/bash_completion.d/ghostty"
    cp "$out/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d/ghostty.fish" "$out/share/fish/vendor_completions.d/ghostty.fish"
    cp "$out/Applications/Ghostty.app/Contents/Resources/zsh/site-functions/_ghostty" "$out/share/zsh/site-functions/_ghostty"

  '';

  meta = with lib; {
    description = "Terminal emulator that uses platform-native UI and GPU acceleration";
    homepage = "https://ghostty.org/";
    license = licenses.unfree;
    platforms = platforms.darwin;
    maintainers = [mulatta];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    knownVulnerabilities = [];
  };
}
