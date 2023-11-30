{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      stateVersion = "23.11";

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
          system.stateVersion = stateVersion;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              { home.stateVersion = stateVersion; }
            ];
          };
        }
        ./modules/audio.nix
        ./modules/base.nix
        ./modules/bash.nix
        ./modules/devops.nix
        ./modules/dircolors.nix
        ./modules/emacs.nix
        ./modules/firefox.nix
        ./modules/fonts.nix
        ./modules/gaming.nix
        ./modules/git.nix
        ./modules/go.nix
        ./modules/gpg.nix
        ./modules/hardware.nix
        ./modules/justwatch.nix
        ./modules/networking.nix
        ./modules/nextcloud.nix
        ./modules/nixos.nix
        ./modules/phone.nix
        ./modules/printer.nix
        ./modules/python.nix
        ./modules/rclone.nix
        ./modules/sway.nix
        ./modules/users.nix
        ./modules/virtualisation.nix
        ./modules/windows.nix
        ./modules/xdg.nix
      ];
    in
    {
      nixosConfigurations = {
        butterfly = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = modules ++ [
            nixpkgs-hardware.nixosModules.lenovo-thinkpad-x13-yoga
            ./butterfly.nix
            ./modules/laptop.nix
          ];
        };
        josephine = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = modules ++ [
            nixpkgs-hardware.nixosModules.common-pc-ssd
            ./josephine.nix
          ];
        };
      };
    };
}
