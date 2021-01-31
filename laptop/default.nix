{ pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
  ];

  environment.systemPackages = with pkgs; [
    powertop
    s-tui
    brightnessctl
  ];

}
