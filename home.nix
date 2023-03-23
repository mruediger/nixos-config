{ pkgs, ... }:
{
  home.stateVersion = "22.11";

  home.pointerCursor = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
    gtk.enable = true;
  };

  gtk.enable = true;
  gtk.theme = {
    name = "Paper";
    package = pkgs.paper-gtk-theme;
  };

  gtk.iconTheme = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
  };

  gtk.cursorTheme = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
  };
}
