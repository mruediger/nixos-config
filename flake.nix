{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , emacs-overlay
    , ...
    }@inputs:
    let
      system = "x86_64-linux";

      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          unstable-overlay
          emacs-overlay.overlay
        ];
      };

      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.users.bag = import ./home;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        ./system
        ./config/base.nix
        ./config/bash.nix
        ./config/devops.nix
        ./config/emacs.nix
        ./config/hardware.nix
        ./config/justwatch.nix
        ./config/printer.nix
        ./config/users.nix
        ./config/virtualisation.nix
        ./config/python.nix
        ./config/phone.nix
        ./config/windows.nix
        ./modules/gpg.nix
      ];
    in
    {
      nixosConfigurations = {
        butterfly = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = modules ++ [
            nixos-hardware.nixosModules.lenovo-thinkpad-x13-yoga
            ./butterfly.nix
            ./config/laptop.nix
          ];
        };
        josephine = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = modules ++ [
            nixos-hardware.nixosModules.common-pc-ssd
            ./josephine.nix
          ];
        };
      };
    };
}
