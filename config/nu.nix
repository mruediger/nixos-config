{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.nushell
  ];
}
