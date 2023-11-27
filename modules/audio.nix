{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    helvum
    pulseaudio
  ];

  security.rtkit.enable = true;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.etc =
    let
      json = pkgs.formats.json { };
    in
    {
      "pipewire/pipewire.conf.d/99-rtp-network.conf".source = json.generate "99-rtp-network.conf"
        {
          "context.modules" = [
            { name = "libpipewire-module-rtp-sink"; args = { }; }
            { name = "libpipewire-module-rtp-source"; args = { }; }
            { name = "libpipewire-module-rtp-session"; args = { }; }
          ];
        };

      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
}

