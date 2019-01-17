{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    termite
    pass
    brightnessctl
    i3lock
    pavucontrol
    unstable.sway
  ];

  programs.sway.enable = true;
  programs.sway.extraSessionCommands = ''
    export XKB_DEFAULT_LAYOUT=de
    export XKB_DEFAULT_VARIANT=neo
  '';

  services.xserver = {
    enable = true;
    autorun = true;
    exportConfiguration = true;

    layout = "de";
    xkbVariant = "neo";

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    displayManager = {
      lightdm.enable = true;
    };

    windowManager = {
      default = "awesome";
      awesome.enable = true;
    };
  };
}
