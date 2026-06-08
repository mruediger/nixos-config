{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mc
    lf
    joshuto
    mucommander
    thunar
    thunar-volman
    thunar-archive-plugin
    thunar-media-tags-plugin
  ];
}
