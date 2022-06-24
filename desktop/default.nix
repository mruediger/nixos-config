{ pkgs, ... }:
{
  imports = [
    ./devops.nix
    ./emacs.nix
    ./go.nix
    ./phone.nix
    ./printer.nix
    ./scala.nix
    ./java.nix
    ./virtualisation.nix
    ./rclone.nix
    ./python.nix
    ./justwatch.nix
    ./minecraft.nix
    ./windows.nix
    ./yubikey.nix
    ./gaming.nix
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
}
