{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fontpreview
  ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      cantarell-fonts
      font-awesome
      inconsolata
      iosevka
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
    ];
  };
}
