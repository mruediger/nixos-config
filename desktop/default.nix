{ pkgs, ... }:
{
  imports = [
    ./devops.nix
    ./emacs.nix
    ./go.nix
    ./phone.nix
    ./printer.nix
    ./rust.nix
    ./virtualisation.nix
    ./windows.nix
    ./yubikey.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    calibre
    chromium
    feh
    firefox-wayland
    gparted
    hexchat
    linphone
    mpv
    pass
    pavucontrol
    rambox
    scrot
    skypeforlinux
    texlive.combined.scheme-full
    wine
    xclip
    zoom-us
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

    exportConfiguration = true;

    layout = "de";
    xkbVariant = "neo";

    libinput = {
      enable = true;
      tapping = false;
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome3.enable = true;

    serverFlagsSection = ''
      Option "BlankTime"   "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
      '';
  };
}
