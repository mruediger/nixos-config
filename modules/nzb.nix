{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sabnzbd
    nzbget
  ];

}
