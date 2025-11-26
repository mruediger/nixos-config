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
    vulkan-tools
    mesa-demos
    amdgpu_top
    nvtopPackages.amd
    vdpauinfo
    gamemode
    mangohud
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };

      # Warning: GPU optimisations have the potential to damage hardware
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
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
