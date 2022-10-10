{ config, pkgs, lib, ... }:
{
  imports = [
    ./desktop
    ./config/audio.nix
    ./config/base.nix
    ./config/bash.nix
    ./config/devops.nix
    ./config/emacs.nix
    ./config/hardware.nix
    ./config/justwatch.nix
    ./config/laptop.nix
    ./config/networking.nix
    ./config/nixos.nix
    ./config/printer.nix
    ./config/sway.nix
    ./config/users.nix
    ./config/yubikey.nix
    ./config/virtualisation.nix
  ];

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
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages =  [
      pkgs.wireguard-tools
      config.boot.kernelPackages.rtl8192eu
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

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e717f901-6c5b-4aac-94a2-691cee2f6b72"; }
    ];

  nix = {
    maxJobs = lib.mkDefault 12;
  };

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
