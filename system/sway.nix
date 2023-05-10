{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    swaylock
  ];

  services.dbus.enable = true;
  services.pipewire.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}