{
  pkgs,
  config,
  ...
}: {
  programs.pandoc = {
    enable = true;
    package = pkgs.pandoc;

    #   defaults = {
    #     "metadata" = {
    #       author = "Seungwon Lee";
    #       lang = "ko";
    #     };

    #     "pdf-engine" = "xelatex";
    #     "variables" = {
    #       fontsize = "11pt";
    #       mainfont = "Noto Serif CJK KR";
    #       sansfont = "Noto Sans CJK KR";
    #       monofont = "D2Coding";
    #       geometry = "margin=1in";
    #     };

    #     "reference-doc" = ./reference-docs/default.docx;

    #     "standalone" = true;
    #     "table-of-contents" = true;
    #     "number-sections" = true;
    #   };

    #   templates = {
    #     "default.latex" = ./templates/custom-latex-template.tex;
    #     "default.html" = ./templates/custom-html-template.html;
    #   };

    #   citationStyles = [
    #     ./citation-styles/apa.csl
    #   ];
  };

  # home.sessionVariables = {
  #   PANDOC_PATH = "${config.programs.pandoc.finalPackage}/bin/pandoc";

  #   PANDOC_TEMPLATES = "${config.home.homeDirectory}/.local/share/pandoc/templates";

  #   PANDOC_DEFAULTS_FILE = "${config.programs.pandoc.defaultsFile}";
  # };
}
