{ pkgs, ... }:
{
  imports = [
    ./devops.nix
    ./emacs.nix
    ./go.nix
    ./java.nix
    ./mozilla-overlay.nix
    ./rust.nix
    ./voip.nix
    ./windows.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
    mpv
    pavucontrol
    chromium
    feh
    scrot
    hexchat
    xclip
  ];

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services.xserver = {
    enable = true;
    autorun = true;

    layout = "de";
    xkbVariant = "neo";

    libinput = {
      enable = true;
      tapping = false;
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    videoDrivers = [ "intel" ];
    serverFlagsSection = ''
      Option "BlankTime"   "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
      '';
  };
}
