{
  description = "SWN's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nur.url = "github:nix-community/NUR";
    # mulatta-nur.url = "github:mulatta/NUR";
    charmbracelet-nur.url = "github:charmbracelet/nur";
    goreleaser-nur.url = "github:goreleaser/nur";

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
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , sops-nix
    , nur
    , charmbracelet-nur
    , darwin
    , nix-homebrew
    , nix-index-database
    , goreleaser-nur
    , ...
    }:
    let
      overlays = [
        (_final: prev: {
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              # mulatta = import mulatta-nur { pkgs = prev; };
              charmbracelet = import charmbracelet-nur { pkgs = prev; };
              goreleaser = import goreleaser-nur { pkgs = prev; };
            };
          };
        })
      ];
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = overlays;
        }
      );
    in
    {
      darwinConfigurations = {
        "macbook-pro-m1" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            # input modules
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager

            # specify modules
            ./modules/darwin

            # user-defined modules
            ./users/seungwon/darwin
            ./users/seungwon/home.nix
          ];
        };
      };

      nixosConfigurations = {
        mulatta = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # input modules
            home-manager.nixosModules.home-manager

            # hardware specification
            ./hardwares/eq12.nix

            # specify modules
            ./modules/nixos

            # user-defined modules
            ./users/mulatta/nixos
            ./users/mulatta/home.nix
          ];
        };
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              (writeScriptBin "dot-clean" ''
                nix-collect-garbage -d --delete-older-than 30d
              '')
              (writeScriptBin "dot-release" ''
                tag="$(date +%Y).$(expr $(date +%m) + 0).$(expr $(date +%d) + 0)"
                git tag -m "$tag" "$tag"
                git push --tags
                goreleaser release --clean
              '')
              (writeScriptBin "dot-sync" ''
                git pull --rebase origin main
                nix flake update
                dot-clean
                dot-apply
              '')
              (writeScriptBin "dot-apply" ''
                if test $(uname -s) == "Linux"; then
                  sudo nixos-rebuild switch --flake .#
                fi
                if test $(uname -s) == "Darwin"; then
                  nix build "./#darwinConfigurations.$(hostname | cut -f1 -d'.').system"
                  ./result/sw/bin/darwin-rebuild switch --flake .
                fi
              '')
            ];
          };
        }
      );
    };
}
