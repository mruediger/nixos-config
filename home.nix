{ pkgs, ... }:
{
  home.stateVersion = "22.11";

  gtk.enable = true;
  gtk.theme = {
    name = "Paper";
    package = pkgs.paper-gtk-theme;
  };

  gtk.iconTheme = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
  };

}
