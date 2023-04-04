{ config, pkgs, ... }:
{
  home.stateVersion = "22.11";

  home.pointerCursor = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
    gtk.enable = true;
  };

  imports = [
    ./git.nix
    ./gpg.nix
    ./sway.nix
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Paper";
      package = pkgs.paper-gtk-theme;
    };

    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };

    cursorTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/";
      documents = "${config.home.homeDirectory}/doc";
      templates = "${config.home.homeDirectory}/doc/templates";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/media/music";
      pictures = "${config.home.homeDirectory}/media/pictures";
      videos = "${config.home.homeDirectory}/media/videos";
      publicShare = "${config.home.homeDirectory}/public";
    };
  };

  programs.termite = {
    enable = true;

    scrollbackLines = 10000;
    clickableUrl = false;
    scrollOnOutput = false;
    scrollOnKeystroke = true;

    colorsExtra = ''
      foreground = #657b83
      foreground_bold = #073642
      foreground_dim = #888888
      background = #fdf6e3
      cursor = #586e75

      # if unset, will reverse foreground and background
      highlight = #839496

      # colors from color0 to color254 can be set
      color0 = #073642
      color1 = #dc322f
      color2 = #859900
      color3 = #b58900
      color4 = #268bd2
      color5 = #d33682
      color6 = #2aa198
      color7 = #eee8d5
      color8 = #002b36
      color9 = #cb4b16
      color10 = #586e75
      color11 = #657b83
      color12 = #839496
      color13 = #6c71c4
      color14 = #93a1a1
      color15 = #fdf6e3
    '';
  };
}
