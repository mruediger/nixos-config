
# see https://github.com/colemickens/nixpkgs-wayland
{ pkgs, lib, unstable, ... } @ args:
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
      wl-clipboard
      xdg-user-dirs
    ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };


  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.gtkUsePortal = true;

  environment.sessionVariables = {
     MOZ_ENABLE_WAYLAND = "1";
     XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
     XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
  };


  programs.waybar.enable = true;

  services.pipewire.enable = true;

  programs.qt5ct.enable = true;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    fzf
    i3status
    firefox-wayland
    alacritty
    xss-lock
    startsway
    gnome3.adwaita-icon-theme
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
  ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

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
