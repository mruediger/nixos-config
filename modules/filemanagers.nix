{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mc
    lf
    joshuto
    mucommander
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
  ];
}
