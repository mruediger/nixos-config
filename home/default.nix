{ config, pkgs, ... }:
{
  home.stateVersion = "22.11";

  home.pointerCursor = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
    gtk.enable = true;
  };

  imports = [
    ./sway.nix
    ./firefox.nix
    ./dircolors.nix
    ./rclone.nix
    ./rclone_bisync.nix
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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 10;
      };
      colors = {
        primary = {
          background = "#fdf6e3";
          foreground = "#657b83";
        };
        cursor = {
          text = "#fdf6e3";
          cursor = "#657b83";
        };
        #Normalcolors
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };
        #Brightcolors
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
      };
    };
  };

  home.file.".dir_colors".text = builtins.readFile ./dir_colors;
}
