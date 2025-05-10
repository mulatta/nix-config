{pkgs, ...}: {
  language-server = {
    # python language server
    ruff = {
      command = "${pkgs.ruff}/bin/ruff";
      args = ["server"];
      config.settings = {
        lineLength = 88; # default black style
        lint.select = [
          "E4"
          "E7"
          "F"
        ];
        format.preview = true;
        # type checker
        pyright = {
          enabled = true;
          typeCheckingMode = "basic"; # or "strict"
        };
      };
    };
    # rust language server
    rust-analyzer = {
      command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    };
    # nix language server
    nixd = {
      command = "nixd";
    };
    # toml language server
    taplo = {
      command = "${pkgs.taplo}/bin/taplo";
    };
    # markdown language server
    marksman = {
      command = "${pkgs.marksman}/bin/marksman";
    };
  };

  language = [
    # python
    {
      name = "python";
      scope = "source.python";
      injection-regex = "python";
      file-types = ["py"];
      shebangs = ["python"];
      roots = [
        "pyproject.toml"
        "setup.py"
        "Poetry.lock"
        "requirements.txt"
      ];
      language-servers = [
        "ruff"
        "pylsp"
      ];
      formatter = {
        command = "${pkgs.ruff}/bin/ruff";
        args = [
          "format"
          "-"
        ];
      };
      auto-format = true;
    }
    # rust
    {
      name = "rust";
      scope = "source.rust";
      file-types = ["rs"];
      roots = [
        "Cargo.toml"
        "Cargo.lock"
      ];
      language-servers = ["rust-analyzer"];
      auto-format = true;
    }
    # nix
    {
      name = "nix";
      scope = "source.nix";
      file-types = ["nix"];
      language-servers = [
        "nixd"
        "nil"
      ];
      formatter.command = "alejandra";
      auto-format = true;
    }
    # toml
    {
      name = "toml";
      scope = "source.toml";
      file-types = ["toml"];
      language-servers = ["taplo"];
      auto-format = true;
    }
    # markdown
    {
      name = "markdown";
      scope = "source.markdown";
      file-types = [
        "md"
        "markdown"
      ];
      language-servers = ["marksman"];
      formatter = {
        command = "${pkgs.nodePackages.prettier}/bin/prettier";
        args = [
          "--parser"
          "markdown"
        ];
      };
      auto-format = true;
    }
  ];

  grammars = {
    name = "python";
    source = {
      git = "https://github.com/tree-sitter/py-tree-sitter";
    };
  };
}
