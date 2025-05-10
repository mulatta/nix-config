{
  description = "SWN's darwin system flake";
  outputs = inputs @ {
    self,
    nixpkgs,
    systems,
    home-manager,
    darwin,
    ...
  }: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    # ======== Helper Functions ========
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    overlays = import ./overlays {inherit inputs outputs;};

    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # ======== Darwin Configurations ========
    darwinConfigurations = {
      rhesus = darwin.lib.darwinSystem {
        modules = [./hosts/rhesus];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    # ======== NixOS Configurations ========
    nixosConfigurations = {
      mulatta = nixpkgs.lib.nixosSystem {
        modules = [./hosts/mulatta];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    # ======== Home Configurations ========
    homeConfigurations = {
      "seungwon@rhesus" = lib.homeManagerConfiguration {
        modules = [
          ./home/seungwon/rhesus.nix
          ./home/seungwon/nixpkgs.nix
        ];
        pkgs = pkgsFor.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "seungwon@mulatta" = lib.homeManagerConfiguration {
        modules = [
          ./home/seungwon/mulatta.nix
          ./home/seungwon/nixpkgs.nix
        ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };

  nixConfig = {
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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
  };
}
