{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    mozilla-overlay = {
      url = "github:mozilla/nixpkgs-mozilla";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self
    , nixpkgs
    , nixpkgs-unstable
    , nixos-hardware
    , emacs-overlay
    , mozilla-overlay
    , ... }@inputs:
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
        config = { allowUnfree = true; };
        overlays = [
          unstable-overlay
          emacs-overlay.overlay
        ];
      };

      modules = [
        ./desktop
        ./config/audio.nix
        ./config/base.nix
        ./config/bash.nix
        ./config/devops.nix
        ./config/emacs.nix
        ./config/hardware.nix
        ./config/justwatch.nix
        ./config/networking.nix
        ./config/nixos.nix
        ./config/printer.nix
        ./config/sway.nix
        ./config/users.nix
        ./config/yubikey.nix
        ./config/virtualisation.nix
        ./config/python.nix
      ];
    in
    {
      nixosConfigurations = {
        butterfly = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = modules ++ [
            nixos-hardware.nixosModules.common-pc-ssd
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
