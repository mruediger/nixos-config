# see https://github.com/colemickens/nixpkgs-wayland
{ pkgs, ... }:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
in
{
  nixpkgs.overlays = [ waylandOverlay ];

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

  users.extraUsers.bag.extraGroups = ["sway"];

  environment.systemPackages = with pkgs; [
    fzf
  ];
}
