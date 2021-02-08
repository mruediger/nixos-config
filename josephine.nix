{ config, pkgs, lib, ... } @ args:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports = [
    ./base
    (import ./desktop ({unstable = unstable;} // args ))
    ./desktop/sway.nix
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
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with pkgs; [ wireguard ];
    loader = {
      timeout = 120;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
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

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
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
      privateKeyFile = "${toString ./.}" + "/wireguard-blueboot.key";
      peers = [{
        publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
        allowedIPs = [ "10.42.42.0/24" ];
        endpoint = "blueboot.org:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  networking.firewall  ={
    enable = true;
    allowedTCPPorts = [ 22 4713 7680 ];
  };

}
