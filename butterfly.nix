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
    resumeDevice = config.fileSystems."/".device;
    kernelParams = [
      "resume_offset=20791296" #offset by filefrag -v /swapfile
      "acpi_backlight=native"  #allow brightnessctl to work
      "i915.enable_guc=2"      #GuC/HuC firmware
      "i915.enable_fbc=0"      #frambuffer compression for powersaving
      "i915.enable_psr=0"      #panel self refresh for powersaving
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

  swapDevices = [{
    device = "/swapfile";
  }];

  networking = {
    hostName = "butterfly";
     useDHCP = false;
     interfaces = {
       enp0s31f6.useDHCP = true;
       wlp0s20f3.useDHCP = true;
     };
     firewall  ={
       enable = true;
       allowedTCPPorts = [ 22 4713 7680 ];
     };
     wireguard.interfaces = {
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
  };

  hardware = {
    video.hidpi.enable = true;
    trackpoint.enable = true;
    trackpoint.emulateWheel = true;
    trackpoint.device = "TPPS/2 Elan TrackPoint";
    cpu.intel.updateMicrocode = true;
  };

  services.fwupd = {
    enable = true;
  };



  environment.systemPackages = with pkgs; [
    libwacom
    xf86_input_wacom
  ];

  services.xserver.libinput.enable = true;
  services.xserver.libinput.naturalScrolling = false;
  services.xserver.libinput.tapping = true;
  services.xserver.libinput.disableWhileTyping = true;
  services.xserver.libinput.horizontalScrolling = false;
  services.xserver.modules = [ pkgs.xf86_input_wacom ];
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

  services.resolved = {
    enable = true;
    domains = [
      "local"
    ];
    fallbackDns = [
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };

  services.logind = {
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };

  hardware.pulseaudio.zeroconf = {
    publish.enable = false;
    discovery.enable = true;
  }
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
