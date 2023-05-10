{ pkgs, ... }:
{
  home.file.".dir_colors".text = builtins.readFile ./dir_colors;
  programs.bash.initExtra = ''
    eval $(${pkgs.coreutils}/bin/dircolors -b ~/.dir_colors)
  '';
}
