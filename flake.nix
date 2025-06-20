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
    lib = nixpkgs.lib // home-manager.lib // darwin.lib;

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

    # packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./utils/shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: import ./utils/formatter.nix {inherit pkgs;});
    checks = forEachSystem (pkgs: import ./utils/checks.nix {inherit inputs outputs pkgs;});
    deploy = import ./utils/deploy {inherit inputs outputs lib;};

    # ======== Darwin Configurations ========
    darwinConfigurations = {
      rhesus = lib.darwinSystem {
        modules = [./hosts/rhesus];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    # ======== NixOS Configurations ========
    nixosConfigurations = {
      mulatta = lib.nixosSystem {
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
    extra-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    yazi.url = "github:sxyazi/yazi";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
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
