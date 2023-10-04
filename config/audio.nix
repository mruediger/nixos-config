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
      "pipewire/pipewire-pulse.conf.d/99-network.conf".source = json.generate "99-network.conf"
        {
          "pulse.properties" = {
            "server.address" = [
              "unix:native"
              { address = "tcp:0.0.0.0:4713"; "client.access" = "allowed"; }
            ];
          };
          "context.exec" = [
            { path = "${pkgs.pulseaudio}/bin/pactl"; args = "load-module module-always-sink"; }
            { path = "${pkgs.pulseaudio}/bin/pactl"; args = "load-module module-zeroconf-publish"; }
          ];
        };

      "pipewire/pipewire.conf.d/zeroconf.conf".source = json.generate "zeroconf.conf"
        {
          "context.modules" = [
            { name = "libpipewire-module-zeroconf-discover"; args = { }; }
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

