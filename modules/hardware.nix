{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
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
