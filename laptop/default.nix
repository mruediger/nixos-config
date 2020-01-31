{ pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
  ];

  environment.systemPackages = with pkgs; [
    powertop
    s-tui
  ];

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="pci", ATTR{power/control}="auto"
      SUBSYSTEM=="i2c", ATTR{power/control}="auto"
      SUBSYSTEM=="net", ATTR{power/wakeup}="disabled"
    '';
  };

  boot = {
    kernel.sysctl."vm.dirty_writeback_centisecs" = 1500;
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';
  };

  services.tlp.enable = false;

  services.upower.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powerUpCommands = ''
      echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';
    '';
  };


}
