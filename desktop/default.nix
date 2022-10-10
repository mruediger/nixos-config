{ pkgs, ... }:
{
  imports = [
    ./go.nix
    ./phone.nix
    ./python.nix
    ./minecraft.nix
    ./windows.nix
    ./gaming.nix
  ];
}
