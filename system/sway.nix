{ pkgs, lib, ... }:
{
  services.dbus.enable = true;
  services.pipewire.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
