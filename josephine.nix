{ config, pkgs, lib, ... }:
{

  networking = {
    hostName = "josephine";
    interfaces.eno1.useDHCP = true;
  };

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        nvme1n1p1 = {
          device = "/dev/nvme1n1p1";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages =  [
      pkgs.wireguard-tools
    ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b579fa81-0b6e-48ef-b2cc-8dabecd06086";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p2";
      fsType = "vfat";
    };

  fileSystems."/mnt/windows" =
    {
      device = "/dev/disk/by-uuid/4E98E4F498E4DB89";
      fsType = "ntfs";
    };

  fileSystems."/mnt/archive" =
    {
      device = "/dev/disk/by-uuid/CADEFC1ADEFBFD0F";
      fsType = "ntfs3";
      options = [ "defaults" "user" "rw" "noauto" ];
    };

  swapDevices = [{ device = "/dev/vg/swap"; }];

  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  services.logind = {
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.42.42.4/32" ];
      privateKeyFile = "/home/bag/src/nixos/nixos-config/wireguard-blueboot.key";
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  system.stateVersion = "22.05";
}
