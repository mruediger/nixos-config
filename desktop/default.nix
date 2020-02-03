{ pkgs, unstable, ... } @ args:
{
  imports = [
    (import ./devops.nix ({unstable = unstable;} // args ))
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
    unstable.calibre
    chromium
    evince
    feh
    unstable.firefox
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
