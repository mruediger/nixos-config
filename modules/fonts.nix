{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fontpreview
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
      cantarell-fonts
      font-awesome
      inconsolata
      iosevka
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      roboto
      roboto-mono
      monaspace
      fira-code
    ];
  };
}
