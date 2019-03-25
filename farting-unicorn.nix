{ config, pkgs, ... }:

let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  xdg-dotfiles = fetchTarball https://github.com/mruediger/xdg-dotfiles/archive/master.tar.gz;
in
{
  imports = [
    (hardwareTarball + "/lenovo/thinkpad/x1/6th-gen")
    ./base
    ./desktop
    ./laptop
    xdg-dotfiles
  ];

  networking.hostName = "farting-unicorn";

  swapDevices = [
    { device = "/swapfile";
      size = 20480;
    }
  ];

  boot = {
    kernelPackages = with pkgs; unstable.linuxPackages_latest;
    resumeDevice = config.fileSystems."/".device;
    kernelParams = [
      "resume_offset=1679360" #offset by filefrag -v /swapfile
      "i915.enable_guc=2"     #GuC/HuC firmware
      "i915.enable_fbc=0"     #frambuffer compression for powersaving
      "i915.enable_psr=0"     #panel self refresh for powersaving
    ];
  };

  services.logind = {
    extraConfig = ''
      HandleSuspendKey=hibernate
    '';
  };

  services.xserver.dpi = 135;
  fonts.fontconfig.dpi = 135;

  systemd.services."i3lock" = {
    enable = true;
    before = [ "sleep.target" "suspend.target" ];
    wantedBy = [ "sleep.target" "suspend.target" ];
    serviceConfig = {
      Type = "forking";
      User = "bag";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.i3lock}/bin/i3lock -i /home/bag/src/dotfiles/templates/w95lock.png";
    };
  };
}
