{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bash,
  nodePackages,
}:
buildNpmPackage rec {
  pname = "drawdb";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "drawdb-io";
    repo = "drawdb";
    rev = "580ccff6cf349643590632c55ac254f431203596";
    hash = "sha256-PHY1dJqlZx9faMGv35xppn+JbQQYqiQsfzwc3J7wuWg=";
  };
  npmDepsHash = "sha256-Yd8h1IuuG3cTlDhb4g0V/MEPu+WCyGXg1f69rGTAx3I=";
  buildPhase = ''
    npm run build
  '';
  installPhase = ''
    mkdir -p $out/share/${pname}
    cp -r dist/* $out/share/${pname}/
    mkdir -p $out/bin
    cat > $out/bin/drawdb << EOF
    #!${bash}/bin/bash
    PORT=\''${1:-8000}
    echo "Starting DrawDB at http://localhost:\$PORT/"
    exec ${nodePackages.serve}/bin/serve -s $out/share/${pname} -l \$PORT
    EOF
    chmod +x $out/bin/drawdb
  '';
  buildInputs = [
    nodePackages.serve
  ];
  meta = with lib; {
    description = "Free, simple, and intuitive online database diagram editor and SQL generator";
    homepage = "https://github.com/drawdb-io/drawdb";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
