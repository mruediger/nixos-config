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
    ];
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands =
      ''
        export MOZ_ENABLE_WAYLAND=1
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
      '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  programs.waybar.enable = true;

  services.pipewire.enable = true;

  environment.systemPackages = with pkgs; [
    fzf
    i3status
    unstable.firefox-wayland
    alacritty
    xss-lock
    startsway
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
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # startup
  # https://github.com/sworne/sway

  # screen sharing
  # https://github.com/NixOS/nixpkgs/issues/91218
  # https://github.com/calbrecht/nixpkgs-overlays
  # https://soyuka.me/make-screen-sharing-wayland-sway-work/
}
