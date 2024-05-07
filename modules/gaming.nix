{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lutris-free
    prismlauncher #minecraft
    libratbag
    piper
    steam
    wine
    mumble
    gcompris
    tuxpaint
    superTux
    superTuxKart
  ];

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    steam-hardware.enable = true;
    pulseaudio.support32Bit = true;
  };

  #mouse
  services.dbus.packages = [ pkgs.unstable.libratbag ];
  systemd.packages = [ pkgs.unstable.libratbag ];

}
