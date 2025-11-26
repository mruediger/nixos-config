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
          device = "/dev/disk/by-uuid/a90e4023-f0dd-4353-aced-933d051c14ba";
          preLVM = true;
          allowDiscards = true;
        };
        swap = {
          device = "/dev/sda3";
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_lqx;
    kernelParams = [
      "amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
    ];
    extraModulePackages = [
      pkgs.wireguard-tools
    ];
  };

  fileSystems."/" =
    {
      device = "/dev/mapper/vg-root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = ["umask=0077"];
    };

  fileSystems."/mnt/windows" =
    {
      device = "/dev/disk/by-uuid/94DCA0A6DCA08458";
      fsType = "ntfs";
      options = [ "defaults" "user" "ro" "noauto" ];
    };

  fileSystems."/mnt/archive" =
    {
      device = "/dev/disk/by-uuid/CADEFC1ADEFBFD0F";
      fsType = "ntfs3";
      options = [ "defaults" "user" "rw" "noauto" ];
    };

  swapDevices = [{ device = "/dev/mapper/swap"; }];

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
      privateKeyFile = "/home/bag/src/nixos/src/wireguard-blueboot.key";
    };
  };

  powerManagement = {
    enable = true;
    #    cpuFreqGovernor = "ondemand";
    cpuFreqGovernor = "performance";
  };

  services.pipewire.extraConfig.pipewire-pulse = {
    "90-pacmd" = {
      "pulse.cmd" = [
        { cmd = "load-module"; args = "module-native-protocol-tcp listen=0.0.0.0"; }
        { cmd = "load-module"; args = "module-zeroconf-discover"; }
        { cmd = "load-module"; args = "module-zeroconf-publish"; }
      ];
    };
  };
  environment.etc."lvm/lvm.conf".text = ''
    devices {
      allow_mixed_block_sizes = 1
    }
    '';

  boot.recoverySystem.enable = true;
}
