# see https://github.com/colemickens/nixpkgs-wayland
{ pkgs, lib, ... }:
let
  startsway = pkgs.writeTextFile {
    name = "startsway";
    destination = "/bin/startsway";
    executable = true;
    text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
          '';
  };

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
        '';
  };
in
{

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaybg
      swaylock
      swayidle
      xwayland
      dmenu
      termite
      grim
      slurp
      waybar
      mako
      sirula
      zathura
      wl-clipboard
      xdg-user-dirs
      pulseaudio #for pactl
      cinnamon.nemo
    ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };



  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  environment.sessionVariables = {
     MOZ_ENABLE_WAYLAND = "1";
     XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
     XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
  };

  programs.waybar.enable = true;

  programs.qt5ct.enable = true;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    firefox-wayland
    fzf
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
    gtk-engine-murrine
    gtk_engines
    i3status
    lxappearance
    slack
    startsway
    unstable.google-chrome
    xss-lock
  ];

  # screen sharing
  # https://github.com/NixOS/nixpkgs/issues/91218
  # https://github.com/calbrecht/nixpkgs-overlays
  # https://soyuka.me/make-screen-sharing-wayland-sway-work/

  # obs-studio: add wayland to buildInputs
  # obs-studio (git master) has native wayland support.
  # To build further releases of obs-studio this adds wayland to buildInputs
  # https://github.com/obsproject/obs-studio/wiki/Install-Instructions#linux-build-directions
  # https://github.com/obsproject/obs-studio/pull/2484
}
