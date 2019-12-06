{ pkgs, ... }:
{
  imports = [
    ./devops.nix
    ./emacs.nix
    ./go.nix
    ./phone.nix
    ./printer.nix
    ./rust.nix
    ./i3.nix
    ./virtualisation.nix
    ./windows.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    calibre
    chromium
    evince
    feh
    unstable.firefox-wayland
    gimp
    gparted
    hexchat
    linphone
    mpv
    (unstable.pass.override { waylandSupport = true; })
    pavucontrol
    skypeforlinux
    texlive.combined.scheme-full
    wine
    xclip
    zoom-us
    libreoffice
  ];

  fonts = {
    enableDefaultFonts = true;
    enableCoreFonts = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };


  };
}
