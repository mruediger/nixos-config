{ pkgs, ... }:
let
  openconnect = pkgs.callPackage ../packages/openconnect.nix { openssl = null; };
in
{
  environment.systemPackages = with pkgs; [
    citrix_workspace
    openconnect
  ];
}
