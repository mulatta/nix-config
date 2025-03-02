{
  description = "SWN's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nur.url = "github:nix-community/NUR";
    # mulatta-nur.url = "git+ssh://git@github.com/mulatta/NUR.git";
    # secrets.url = "git+ssh://git@github.com/mulatta/secrets.git";
    # secrets = {
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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      # , secrets
      darwin,
      nix-homebrew,
      nix-index-database,
      nur,
      # , mulatta-nur
      ...
    }:
    let
      overlays = [
        (_final: prev: {
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              # mulatta = import mulatta-nur { pkgs = prev; };
            };
          };
        })
        (import ./overlay)
      ];
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
                  nix-index-database.hmModules.nix-index
                  sops-nix.homeManagerModules.sops
                ];

              };
            }
          ];
        };
      };

      nixosConfigurations = {
        mulatta = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./hosts/mulatta
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm";
              home-manager.users.seungwon = {
                imports = [
                  ./modules/common
                  ./modules/nixos
                  ./modules/home.nix
                  nix-index-database.hmModules.nix-index
                  sops-nix.homeManagerModules.sops
                ];

              };
            }
          ];
        };
      };
    };
}
