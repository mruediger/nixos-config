{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox
    termite
    pass
    brightnessctl
    i3lock
    pavucontrol
  ];

  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
    };
    layout = "de";
    xkbVariant = "neo";

    windowManager = {
      default = "awesome";
      awesome = {
        enable = true;
      };
    };
  };
}
