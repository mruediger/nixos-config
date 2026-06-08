{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum
    pulseaudio
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      };
    };
  };

  # Open the PulseAudio TCP port
  networking.firewall.allowedTCPPorts = [ 4713 ];

  # Enable Avahi to broadcast the audio sink
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  # Configure PipeWire to accept network connections
  services.pipewire.extraConfig.pipewire-pulse."99-network.conf" = {
    "context.modules" = [
      {
        name = "libpipewire-module-protocol-pulse";
        args = {
          "server.address" = [ "tcp:4713" ];
        };
      }
      { name = "libpipewire-module-zeroconf-discover"; }
    ];
  };
}
