{ nixpkgs, inputs, overlays }:
{
  system,
  name,
  description ? "",
  program ? "",
  script ? "",
}:
let
  # 중앙에서 정의된 overlays 사용
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ overlays ];
    config = {
      allowUnfree = true;
    };
  };

  # 프로그램 경로가 제공되면 그대로 사용, 아니면 스크립트 생성
  app =
    if program != "" then
      { inherit program; }
    else
      {
        type = "app";
        program =
          let
            scriptPath = pkgs.writeShellScriptBin name script;
          in
          "${scriptPath}/bin/${name}";
      };
in
{
  ${name} = {
    inherit description;
    type = "app";
    program = app.program;
  };
}
