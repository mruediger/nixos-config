{ pkgs, ... }:
{
  imports = [
    ./devops.nix
    ./emacs.nix
    ./go.nix
    ./mozilla-overlay.nix
    ./phone.nix
    ./rust.nix
    ./voip.nix
    ./wine.nix
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
    font-manager
    skypeforlinux
    pass
  ];

  fonts = {
    enableDefaultFonts = true;
    enableCoreFonts = true;
  };
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
