{ pkgs, lib, config, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.kitty
  ];
}
