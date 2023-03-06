# see https://github.com/colemickens/nixpkgs-wayland
{ pkgs, lib, ... }:
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
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

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
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
  environment.systemPackages = with pkgs; [
    configure-gtk
    dbus-sway-environment

    alacritty
    cinnamon.nemo
    dmenu
    dracula-theme # gtk theme
    firefox-wayland
    fzf
    glib # gsettings
    gnome3.adwaita-icon-theme  # default gnome cursors
    grim # screenshot functionality
    gsettings-desktop-schemas
    lxappearance
    mako # notification system developed by swaywm maintainer
    pulseaudio #for pactl
    slack
    slurp # screenshot functionality
    sway
    swaybg
    swayidle
    swaylock
    termite
    unstable.google-chrome
    waybar
    wayland
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    xdg-user-dirs
    xdg-utils # for opening default programs when clicking links
    xss-lock
    xwayland
    zathura
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
    XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
  };

  programs.waybar.enable = true;
  security.polkit.enable = true;

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
