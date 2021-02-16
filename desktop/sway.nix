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
  };

  programs.waybar.enable = true;

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

}
