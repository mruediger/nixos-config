{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.lutris-free
    unstable.prismlauncher #minecraft
    unstable.libratbag
    unstable.piper

    mumble
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
