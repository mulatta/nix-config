{
  description = "SWN's darwin system flake";
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      darwin,
      nix-homebrew,
      nix-index-database,
      disko,
      nixos-anywhere,
      ...
    }:
    let
      # ======== Architectures ========
      darwinSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      supportedSystems = linuxSystems ++ darwinSystems;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # ======== Overlays ========
      overlays = import ./overlays { inherit inputs; };

      # ======== Package Sets ========
      pkgs = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlays ];
          config = {
            allowUnfree = true;
          };
        }
      );

      # ======== Helper Functions ========
      mkSystem = import ./libs/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
      # mkApp = import ./libs/mkApp.nix {
      #   inherit nixpkgs inputs overlays;
      # };
    in
    {
      # ======== Formatter ========
      formatter = forAllSystems (system: pkgs.${system}.nixfmt-rfc-style);

      # ======== Checks ========
      checks = forAllSystems (
        system:
        import ./checks.nix {
          inherit inputs system;
          pkgs = pkgs.${system};
        }
      );

      # ======== DevShell ========
      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = pkgs.${system};
          checks = self.checks.${system};
        }
      );

      # ======== Darwin Configurations ========
      darwinConfigurations = {
        rhesus = mkSystem {
          system = "aarch64-darwin";
          hostname = "rhesus";
          isDarwin = true;
        };
      };

      # ======== NixOS Configurations ========
      nixosConfigurations = {
        mulatta = mkSystem {
          system = "x86_64-linux";
          hostname = "mulatta";
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # secrets.url = "git+ssh://git@github.com/mulatta/secrets.git";
    # nix-secrets = {
    #   url = "path:/Users/seungwon/nix-secrets";
    #   flake = false;
    # };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
