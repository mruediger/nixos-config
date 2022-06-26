{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./base
      ./desktop
      ./desktop/sway.nix
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
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "kvm-intel" "acpi_call"  ];
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = [
      pkgs.wireguard-tools
      config.boot.kernelPackages.acpi_call
      config.boot.kernelPackages.rtl8192eu

    ];
    kernel.sysctl = {
      "vm.swappiness" = 90;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "net.ipv4.conf.enp0s31f6.forwarding" = 1;
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

  fileSystems."/windows" =
    { device = "/dev/nvme0n1p3";
      fsType = "ntfs";
      options = [ "rw" "uid=bag"];
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
      internalInterfaces = ["enp0s31f6"];
    };

    interfaces = {
      wlp0s20f3.useDHCP = true;
      enp0s31f6 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.1";
            prefixLength = 24;
          }];
      };
    };
    firewall  ={
      enable = true;
      allowedTCPPorts = [ 22 4713 7680 ];
      allowedUDPPorts = [
        67 # DHCP
      ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.42.42.2/32" ];
        #privateKeyFile = "${inputs.self}/wireguard-blueboot.key";
        privateKeyFile = "/home/bag/src/nixos/nixos-config/wireguard-blueboot.key";
        peers = [{
          publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
          allowedIPs = [ "10.42.42.0/24" ];
          endpoint = "blueboot.org:51820";
          persistentKeepalive = 25;
        }];
      };
    };
  };

  networking.networkmanager.unmanaged = [ "enp0s31f6" ];

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp0s31f6" ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.1.255;
      option routers 192.168.1.1;
      option domain-name-servers 1.1.1.1;
      option domain-name "lan";
      subnet 192.168.1.0 netmask 255.255.255.0 {
        range 192.168.1.100 192.168.1.200;
      }
    '';
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
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
  };

  nix.autoOptimiseStore = true;

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
