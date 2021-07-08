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
    ./java.nix
    ./virtualisation.nix
    ./justwatch.nix
    ./rclone.nix
    ./python.nix
    (import ./minecraft.nix ({unstable = unstable;} // args ))
    ./windows.nix
    (import ./yubikey.nix ({unstable = unstable;} // args ))
    (import ./gaming.nix ({unstable = unstable;} // args ))
  ];

  environment.systemPackages = with pkgs; [
    chromium
    evince
    google-chrome
    feh
    gimp
    gparted
    hexchat
    mpv
    gitg
    pavucontrol
    texlive.combined.scheme-full
    xclip
    unstable.zoom-us
    libreoffice
    slack
    teams
    skypeforlinux
    unstable.AusweisApp2
    libreoffice
    linphone
    vscode
  ];

  nixpkgs.config.chromium.enableWideVine = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      iosevka
      fira-code
      noto-fonts
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
    extraModules = [ pkgs.pulseaudio-modules-bt ];
 };
}
