{ config, pkgs, ... }:

let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
in
{
  imports = [
    (hardwareTarball + "/lenovo/thinkpad/x1/6th-gen")
    ./base
    ./desktop
    ./laptop
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
      "resume_offset=96256"   #offset by filefrag -v /swapfile
      "i915.enable_guc=2"     #GuC/HuC firmware
      "i915.enable_fbc=0"     #frambuffer compression for powersaving
      "i915.enable_psr=0"     #panel self refresh for powersaving
    ];
    extraModulePackages = [ config.boot.kernelPackages.wireguard ];
    blacklistedKernelModules = [ "amdgpu" ];
  };

  services.logind = {
    extraConfig = ''
      HandleSuspendKey=hibernate
    '';
  };



  systemd.services.swaylock = {
    enable = true;
    before = [ "sleep.target" "suspend.target" ];
    wantedBy = [ "sleep.target" "suspend.target" ];
    serviceConfig = {
      Type = "forking";
      User = "bag";
      Environment = "WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000";
      ExecStart = "${pkgs.swaylock}/bin/swaylock -i /home/bag/src/dotfiles/templates/w95lock.png";
    };
  };

  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.42.42.2/32" ];
      privateKeyFile = "${toString ./.}" + "/wireguard-blueboot.key";
      peers = [{
        publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
        allowedIPs = [ "10.42.42.0/24" ];
        endpoint = "blueboot.org:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  nixpkgs.overlays = [ (import ./overlays/libinput.nix) ];
}
