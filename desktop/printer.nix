{ pkgs, ... }:
{
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [
    pkgs.samsung-unified-linux-driver_1_00_37
  ];
}
