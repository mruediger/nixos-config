{  pkgs, unstable, ... } @ args:
{
  environment.systemPackages = with pkgs; [
    snes9x-gtk
  ];

  programs.steam.enable = true;
}
