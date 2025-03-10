{
  description = "SWN's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nur.url = "github:nix-community/NUR";
    mulatta-nur.url = "git+ssh://git@github.com/mulatta/NUR.git";

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
    , darwin
    , nix-homebrew
    , nix-index-database
    , nur
    , mulatta-nur
    , ...
    }:
    let
      overlays = [
        (_final: prev: {
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              mulatta = import mulatta-nur { pkgs = prev; };
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
        rhesus = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = overlays; }
            ./hosts/rhesus
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm";
              home-manager.users.seungwon = {
                imports = [
                  ./modules/common
                  ./modules/darwin
                  ./modules/home.nix
                  ./modules/common/aldente.nix
                  inputs.nix-index-database.hmModules.nix-index
                ];

              };
            }
          ];
        };
      };

      nixosConfigurations = {
        mulatta = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              { nixpkgs.overlays = overlays; }
              ./hosts/mulatta
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hm";
                home-manager.users.seungwon =
                  {
                    imports = [
                      ./modules/common
                      ./modules.nixos.nix
                      ./modules/home.nix
                      inputs.nix-index-database.hmModules.nix-index
                    ];

                  };
              }
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
              (writeScriptBin "dot-update" ''
                tag="$(date +%Y).$(expr $(date +%m) + 0).$(expr $(date +%d) + 0)"
                git tag -m "$tag" "$tag"
                git push --tags
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
