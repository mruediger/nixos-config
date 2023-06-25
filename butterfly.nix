{ config, pkgs, lib, inputs, ... }:
{
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "i915" ];
      luks.devices."root".device = "/dev/disk/by-uuid/28e194bb-65b6-4ae4-a5d7-0f708b414166";
    };
    resumeDevice = config.fileSystems."/".device;
    kernelParams = [
      "resume_offset=20791296" #offset by filefrag -v /swapfile
      #      "i915.enable_guc=2" #GuC/HuC firmware
      #      "i915.enable_fbc=0" #frambuffer compression for powersaving
      #      "i915.enable_psr=0" #panel self refresh for powersaving
    ];
    kernelModules = [ "kvm-intel" "acpi_call" ];
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call
    ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b896d5b2-8d8f-4199-921a-c28efca7e37d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

  fileSystems."/windows" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs";
      options = [ "rw" "uid=bag" ];
    };

  swapDevices = [{
    device = "/swapfile";
  }];

  networking = {
    hostName = "butterfly";
    useDHCP = false;

    nat = {
      enable = true;
      externalInterface = "wlp0s20f3";
      internalInterfaces = [ "enp0s31f6" ];
    };

    interfaces = {
      wlp0s20f3.useDHCP = true;
      enp0s31f6 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.42.1";
            prefixLength = 24;
          }
        ];
      };
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.42.42.2/32" ];
        privateKeyFile = "/home/bag/src/nixos/nixos-config/wireguard-blueboot.key";
      };
    };
  };

  hardware = {
    trackpoint.enable = true;
    trackpoint.emulateWheel = true;
    trackpoint.device = "TPPS/2 Elan TrackPoint";
  };

  services.xserver.libinput.touchpad = {
    naturalScrolling = false;
    tapping = true;
    disableWhileTyping = true;
    horizontalScrolling = false;
  };

  services.xserver.wacom.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      "TLP_DEFAULT_MODE" = "BAT";
      "CPU_SCALING_GOVERNOR_ON_AC" = "powersave";
      "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
      "START_CHARGE_THRESH_BAT0" = 75;
      "STOP_CHARGE_THRESH_BAT0" = 100;
    };
  };

  services.logind = {
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };

  system.stateVersion = "22.11";
}
