{ ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages;
    kernel.sysctl = {
      "vm.swappiness" = 90;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    ksm.enable = true;
    cpu = {
      amd.updateMicrocode = true;
      cpu.intel.updateMicrocode = true;
    };
  };

  services.fwupd = {
    enable = true;
  };
}
