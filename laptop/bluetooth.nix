{ pkgs, ... }:
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    config.General.Enable="Source,Sink,Media,Socket";
  };
}
