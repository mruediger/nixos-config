{ config, pkgs, ... }:

let
  xdg-dotfiles = (fetchGit https://github.com/mruediger/xdg-dotfiles.git).outPath;
in
{
  imports = [
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

  networking.hostName = "honkhonk";

  services.xserver = {
    videoDrivers = [ "intel" ];
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
