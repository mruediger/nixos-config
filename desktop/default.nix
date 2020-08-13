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
    (import ./steam.nix ({unstable = unstable;} // args ))
  ];

  environment.systemPackages = with pkgs; [
    unstable.calibre
    chromium
    unstable.evince
    unstable.google-chrome
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
    teams
    unstable.skypeforlinux
    google-musicmanager
    unstable.AusweisApp2
    libreoffice
    linphone
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
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" "192.168.1.0/24" ];
    };
    zeroconf = {
      publish.enable = true;
      discovery.enable = true;
    };
    extraModules = [ pkgs.pulseaudio-modules-bt ];
 };
}
