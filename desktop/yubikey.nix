{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    opensc
    pcsctools
    libu2f-host
    yubikey-personalization
  ];
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    libu2f-host
    yubikey-personalization
  ];
  hardware.u2f.enable = true;
}