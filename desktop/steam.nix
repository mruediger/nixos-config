{  pkgs, unstable, ... } @ args:
{
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs; [
    #(unstable.steam.override { extraLibraries =  with pkgs; pkgs: [ libGLU libuuid libbsd alsaLib ]; })
    (steam.override { nativeOnly = true; })
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
}
