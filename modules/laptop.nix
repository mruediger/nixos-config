{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    powertop
    s-tui
    bluetui
  ];

  #  nixpkgs.config = {
  #    packageOverrides = pkgs: {
  #      bluez = pkgs.bluez5;
  #    };
  #  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
}
