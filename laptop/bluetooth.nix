{ pkgs, ... }:
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };


  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    extraConfig = ''
    [General]
    Enable=Source,Sink,Media,Socket
    '';
  };
}
