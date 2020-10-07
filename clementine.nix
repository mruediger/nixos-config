{ config, pkgs, lib,... } @ args:
let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
      ./base
      (import ./desktop ({unstable = unstable;} // args ))
      ./laptop
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "dm-snapshot" "i915" ];
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/4ee3774a-9d92-4359-bdbc-a310df8bc869";
        };
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/dad76c67-12de-486a-96b8-70aabfde72cf";
      fsType = "ext4";
    };

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking = {
    hostName = "clementine";
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };


  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # hardware hdd
  services.hdapsd.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  # hardware ssd
  services.fstrim.enable = true;

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;

  environment.systemPackages = with pkgs; [
    hd-idle
  ];

  systemd.services.hd-idle = {
    description = "External HD spin down daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a sdb -i 60";
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
