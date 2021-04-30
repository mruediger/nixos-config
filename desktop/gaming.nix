{  pkgs, unstable, ... } @ args:
{
  environment.systemPackages = with pkgs; [
    snes9x-gtk
    unstable.lutris-free
    gnome3.adwaita-icon-theme
    unstable.legendary-gl
    wineWowPackages.stable
    unstable.winetricks
  ];

  hardware.opengl.driSupport32Bit = true;

  programs.steam.enable = true;
}
