{ config, pkgs, ... }:

let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  xdg-dotfiles = (fetchGit https://github.com/mruediger/xdg-dotfiles.git).outPath;
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
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = config.fileSystems."/".device;
    kernelParams = [
      "resume_offset=2048000"
      "i915.enable_fbc=1" #frambuffer compression
      "i915.enable_guc=2" #GuC/HuC firmware
      "i915.enable_psr=2" #panel self refresh
    ];
  };

  services.logind = {
    extraConfig = ''
      HandleSuspendKey=hibernate
    '';
  };

  services.xserver.dpi = 135;
  fonts.fontconfig.dpi = 135;
}
