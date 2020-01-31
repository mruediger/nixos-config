{ pkgs, ... }:
let
  unstable = import <unstable> {};
in
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
    ./minecraft.nix
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
    mpv
    (unstable.pass.override { waylandSupport = true; })
    pavucontrol
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

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;

    extraModules = [ pkgs.pulseaudio-modules-bt ];
 };
}
