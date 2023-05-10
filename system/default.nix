{ pkgs, lib, ... }:
let
  user = import ../users/user.nix;
in
{
  imports = [
    ./nixos.nix
    ./fonts.nix
    ./sway.nix
    ./git.nix
  ];

  environment.systemPackages = with pkgs; [
    swaylock
  ];

  security.pam.services.swaylock = { };
}
