{ config, pkgs, lib, ... }:
{
  networking.hostName = "farting-unicorn";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
       "resume_offset=5697536" #offset by filefrag -v /swapfile
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/808ee033-b30f-451b-af36-6074563c13d2";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-abbe1c65-c5c0-4864-9bbb-e12c93552762".device = "/dev/disk/by-uuid/abbe1c65-c5c0-4864-9bbb-e12c93552762";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B001-5ACD";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [{
    device = "/swapfile";
  }];


  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.xserver.synaptics.palmDetect = true;

  #wg genkey > /home/bag/src/nixos/src/wireguard-blueboot.key
  #wg pubkey < /home/bag/src/nixos/src/wireguard-blueboot.key
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.42.42.6/32" ];
      privateKeyFile = "/home/bag/src/nixos/src/wireguard-blueboot.key";
    };
  };

  services.pipewire.extraConfig.pipewire-pulse = {
    "90-pacmd" = {
      "pulse.cmd" = [
        { cmd = "load-module" args = "module-zeroconf-discover" }
      ];
    };
  };
}
