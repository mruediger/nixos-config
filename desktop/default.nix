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
    ./allianz.nix
    (import ./minecraft.nix ({unstable = unstable;} // args ))
    ./windows.nix
    (import ./yubikey.nix ({unstable = unstable;} // args ))
    (import ./steam.nix ({unstable = unstable;} // args ))
  ];

  environment.systemPackages = with pkgs; [
    chromium
    evince
    google-chrome
    feh
    firefox
    gimp
    gparted
    hexchat
    mpv
    pavucontrol
    texlive.combined.scheme-full
    wine
    xclip
    zoom-us
    libreoffice
    slack
    teams
    skypeforlinux
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
