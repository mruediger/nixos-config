{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fontpreview
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
      nerd-fonts.fira-code
      nerd-fonts.roboto-mono
      cantarell-fonts
      font-awesome
      inconsolata
      iosevka
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      roboto
      roboto-mono
      monaspace
      fira-code
    ];

    fontconfig = {
      defaultFonts = {
        serif     = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Roboto" "Noto Color Emoji" ];
        monospace = [ "FiraCode" "Noto Color Emoji" ];
        emoji     = [ "Noto Color Emoji" ];
      };
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "rgb";
    };
  };
}
