{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
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
    extraCompatPackages = [ pkgs.proton-ge-bin ];
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
