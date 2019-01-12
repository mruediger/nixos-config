{ config, pkgs, ... }:

let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  xdg-dotfiles = (fetchGit https://github.com/mruediger/xdg-dotfiles.git).outPath;
in
{
  imports = [
    (hardwareTarball + "/lenovo/thinkpad/x1/6th-gen")
    ./modules/base.nix
    ./modules/bash.nix
    ./modules/xorg.nix
    ./modules/emacs.nix
    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/devops.nix
    ./modules/yubikey.nix
    xdg-dotfiles
  ];

  networking.hostName = "farting-unicorn";

  services.xserver = {
    videoDrivers = [ "intel" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver.dpi = 135;
  fonts.fontconfig.dpi = 135;

  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=90
      START_CHARGE_THRESH_BAT1=75
      STOP_CHARGE_THRESH_BAT1=90
    '';
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    enableAllFirmware = true;
    enableKSM = true;
    cpu = {
      intel.updateMicrocode = true;
    };
  };
}
