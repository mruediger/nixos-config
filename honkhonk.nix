{ config, pkgs, ... }:

{
  imports = [
    ./base
    ./desktop
    ./laptop
    /home/bag/src/nixos/xdg-dotfiles
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
