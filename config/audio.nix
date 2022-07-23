{ ... }:
{
  sound.enable = true;

  hardware.pulseaudio.zeroconf = {
    publish.enable = false;
    discovery.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
