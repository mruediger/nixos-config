{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =  { self, nixpkgs, nixpkgs-unstable, emacs-overlay, home-manager, nixpkgs-hardware,  antigravity-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      stateVersion = "24.11";

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
          (import emacs-overlay)
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
        ./modules/btrfs.nix
        ./modules/desktop.nix
        ./modules/dev.nix
        ./modules/devops.nix
        ./modules/emacs.nix
        ./modules/filemanagers.nix
        ./modules/fonts.nix
        ./modules/gaming.nix
        ./modules/git.nix
        ./modules/go.nix
        ./modules/gpg.nix
        ./modules/hardware.nix
        ./modules/hyprland.nix
        ./modules/java.nix
        ./modules/latex.nix
        ./modules/localization.nix
        ./modules/monitoring.nix
        ./modules/networking.nix
        ./modules/nixos.nix
        ./modules/nu.nix
        ./modules/nzb.nix
        ./modules/opencloud.nix
        ./modules/phone.nix
        ./modules/printer.nix
        ./modules/python.nix
        ./modules/raspberry.nix
        ./modules/rclone.nix
        ./modules/rennsport.nix
        ./modules/ssh.nix
        ./modules/sway.nix
        ./modules/traefik.nix
        ./modules/users.nix
        ./modules/virtualisation.nix
        ./modules/windows.nix
        ./modules/xdg.nix

        {
          environment.systemPackages = [
            antigravity-nix.packages.x86_64-linux.default
          ];
        }

        ./extras/recovery-image.nix
      ];

      emacs-version = pkgs.emacs-pgtk;
    in
      {
        nixosConfigurations = {
          josephine = nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit emacs-version inputs; flake = self; };
            modules = modules ++ [
              nixpkgs-hardware.nixosModules.common-pc-ssd
              nixpkgs-hardware.nixosModules.common-gpu-amd
              nixpkgs-hardware.nixosModules.common-cpu-amd
              nixpkgs-hardware.nixosModules.common-cpu-amd-pstate
              ./josephine.nix
              ./modules/laptop.nix
            ];
          };
          farting-unicorn = nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            specialArgs = { inherit emacs-version inputs; flake = self; };
            modules = modules ++ [
              nixpkgs-hardware.nixosModules.lenovo-thinkpad-x13-amd
              nixpkgs-hardware.nixosModules.common-gpu-amd
              nixpkgs-hardware.nixosModules.common-cpu-amd-pstate
              ./farting-unicorn.nix
              ./modules/laptop.nix
            ];
          };
          recovery-system = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
              ({ pkgs, ... }: {
                environment.systemPackages = with pkgs; [
                  gptfdisk testdisk ddrescue e2fsprogs btrfs-progs
                ];
              })
            ];
          };
        };
        recoveryBundle = {
          x86_64-linux = self.nixosConfigurations.recovery-system.config.system.build.toplevel;
        };
      };
}
