{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mdadm
    dmraid
    btrfs-progs
    btrfs-snap
    btrfs-list
    btrfs-heatmap
    btrfs-assistant
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.swappiness" = 90;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    ksm.enable = true;
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };

  services.fwupd = {
    enable = true;
  };
}
