{ pkgs, ... }:
let
  steam = pkgs.steam.override {
    extraLibraries = pkgs: [
      pkgs.pipewire
    ];
  };
in
{

  environment.systemPackages = with pkgs; [
    snes9x-gtk
    unstable.lutris-free
    gnome3.adwaita-icon-theme
    legendary-gl
    wineWowPackages.stable
    steam
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
