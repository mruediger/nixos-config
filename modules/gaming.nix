{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris-free
    prismlauncher #minecraft
    libratbag
    piper
    wine
    mumble
    gcompris
    tuxpaint
    superTux
    superTuxKart
    gnome3.adwaita-icon-theme
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      ## amdvlk: an open-source Vulkan driver from AMD
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
    steam-hardware.enable = true;
    pulseaudio.support32Bit = true;
  };

  #mouse
  services.dbus.packages = [ pkgs.unstable.libratbag ];
  systemd.packages = [ pkgs.unstable.libratbag ];

}
