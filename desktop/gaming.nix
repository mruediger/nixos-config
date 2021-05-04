{  pkgs, unstable, ... } @ args:
#let
#  steam = pkgs.steam.override {
#    extraLibraries = pkgs: [
#      pkgs.openssl
#      pkgs.nss
#    ];
#  };
#in
{

  environment.systemPackages = with pkgs; [
    snes9x-gtk
    unstable.lutris-free
    gnome3.adwaita-icon-theme
    unstable.legendary-gl
    wineWowPackages.stable
    unstable.winetricks
    unstable.steam
    unstable.steam-run
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    steam-hardware.enable = true;
    pulseaudio.support32Bit  = true;
  };
}
