{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    citrix_workspace
    openconnect
  ];
}
