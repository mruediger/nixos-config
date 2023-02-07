{ pkgs, ... }:
{
  imports = [
    ./go.nix
    ./phone.nix
    ./minecraft.nix
    ./windows.nix
    ./gaming.nix
  ];
}
