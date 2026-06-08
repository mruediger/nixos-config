
{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "farting-unicorn";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  boot.initrd.luks.devices = {
    "root".device = "/dev/disk/by-uuid/47e2e76d-6ca1-4580-a646-4276cbbebd2b";
    "swap".device = "/dev/disk/by-uuid/c893cad7-f94c-4fc0-b044-9889e79c07ad";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/621A-C573";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/mapper/swap"; }
  ];

  services.xserver.synaptics.palmDetect = true;

  #wg genkey > /home/bag/src/nixos/src/wireguard-blueboot.key
  #wg pubkey < /home/bag/src/nixos/src/wireguard-blueboot.key
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.42.42.6/32" ];
      privateKeyFile = "/home/bag/src/nixos/src/wireguard-blueboot.key";
    };
  };

#  services.pipewire.extraConfig.pipewire-pulse = {
#    "90-pacmd" = {
#      "pulse.cmd" = [
#        {
#          cmd = "load-module";
#          args = "module-zeroconf-discover";
#        }
#      ];
#    };
#  };

  services.logind = {
    settings.Login = {
      HandlePowerKey = "hibernate";
    };
  };

  boot.recoverySystem.enable = true;
}
