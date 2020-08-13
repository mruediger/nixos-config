{ pkgs, unstable, ... } @ args:
{
  imports = [
    (import ./devops.nix ({unstable = unstable;} // args ))
    ./emacs.nix
    ./go.nix
    ./phone.nix
    ./printer.nix
    ./rust.nix
    ./scala.nix
    ./i3.nix
    ./virtualisation.nix
    (import ./minecraft.nix ({unstable = unstable;} // args ))
    ./windows.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    unstable.calibre
    chromium
    unstable.evince
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
    unstable.zoom-us
    libreoffice
    slack
  ];

  nixpkgs.config.chromium.enableWideVine = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      iosevka
      fira-code
    ];
  };

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;

    extraModules = [ pkgs.pulseaudio-modules-bt ];
 };
}
