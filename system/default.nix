{ pkgs, lib, ... }:
let
  user = import ../users/user.nix;
in
{
  imports = [
    ./audio.nix
    ./networking.nix
    ./nixos.nix
    ./fonts.nix
    ./sway.nix
    ./git.nix
    ./gaming.nix
    ./go.nix
  ];
}
