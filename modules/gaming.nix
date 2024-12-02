{ pkgs, lib, config, ... }:
{
  nixpkgs.overlays = [
    (self: super:
      {
        piper = super.piper.overrideAttrs ( old: rec {
          version = "104ee170c1028f9d2fac1859dc6dea72efc0648f";
          src = super.fetchFromGitHub {
            owner  = "libratbag";
            repo   = "piper";
            rev    =  version;
            sha256 = "oy8jqwNhPNXed0ptWjkytztNM6uTPmPYYiGaZWbI6CE=";
          };
        });
      })
  ];

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
