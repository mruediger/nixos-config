{ config, pkgs, ... }:

{
  imports = [
    ./base
    ./desktop
    ./laptop
    /home/bag/src/nixos/xdg-dotfiles
  ];

  networking.hostName = "honkhonk";

  time.hardwareClockInLocalTime = true;

}
