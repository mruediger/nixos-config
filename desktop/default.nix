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
    ./rclone.nix
    ./python.nix
    (import ./justwatch.nix ({unstable = unstable;} // args ))
    (import ./minecraft.nix ({unstable = unstable;} // args ))
    ./windows.nix
    ./yubikey.nix
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
    (unstable.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
       wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      '';}))
    libreoffice
    slack
    teams
    skypeforlinux
    unstable.AusweisApp2
    libreoffice
    linphone
    vscode
    freecad
  ];

  nixpkgs.config.chromium.enableWideVine = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      iosevka
      fira-code
      noto-fonts
      roboto-mono
    ];
  };

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "127.0.0.1" "192.168.1.0/24" "192.168.178.0/24" ];
    };
    extraModules = [ pkgs.pulseaudio-modules-bt ];
 };
}
