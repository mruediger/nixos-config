{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fontpreview
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
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
      roboto-mono
      monaspace
      fira-code
    ];
  };
}
