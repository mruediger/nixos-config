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
	      root = {
	        device = "/dev/disk/by-uuid/e497ba1d-3908-4c1e-a8ea-61f0a44b803a";
	        allowDiscards = true;
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
      "resume_offset=144123136"
    ];
    resumeDevice = "/dev/mapper/root";
    extraModulePackages = [
      pkgs.wireguard-tools
    ];
  };

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd"  ];
    };

  fileSystems."//home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/040D-FF6C";
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

  swapDevices = [{ device = "/swapfile"; }];

  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  services.logind = {
    settings.Login = {
      HandlePowerKey = "hibernate";
    };
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
