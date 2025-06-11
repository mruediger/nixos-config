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
    adwaita-icon-theme
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;

  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    steam-hardware.enable = true;
  };

  services.pulseaudio.support32Bit = true;

  #mouse
  services.dbus.packages = [ pkgs.unstable.libratbag ];
  systemd.packages = [ pkgs.unstable.libratbag ];

}
