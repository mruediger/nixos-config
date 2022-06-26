{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
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
    in
    {
      nixosConfigurations = {
        butterfly = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.common-pc-ssd
            ./butterfly.nix
          ];
        };
        josephine = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.common-pc-ssd
            ./josephine.nix
          ];
        };
      };
    };
}
