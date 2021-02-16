{ config, pkgs, lib, ... } @ args:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
      ./base
      (import ./desktop ({ unstable = unstable;} // args ))
      (import ./desktop/sway.nix ({unstable = unstable;} // args))
      ./laptop
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "i915" ];
      luks.devices."root".device = "/dev/disk/by-uuid/28e194bb-65b6-4ae4-a5d7-0f708b414166";
    };
    kernelParams = [
      "acpi_backlight=native"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" "acpi_call"  ];
    extraModulePackages = [
      pkgs.wireguard
      config.boot.kernelPackages.acpi_call
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b896d5b2-8d8f-4199-921a-c28efca7e37d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

  networking = {
    hostName = "butterfly";
     useDHCP = false;
     interfaces = {
       enp0s31f6.useDHCP = true;
       wlp0s20f3.useDHCP = true;
     };
  };

  hardware.video.hidpi.enable = true;
  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;
  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";
  hardware.cpu.intel.updateMicrocode = true;

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


  networking.firewall  ={
    enable = true;
    allowedTCPPorts = [ 22 4713 7680 ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
