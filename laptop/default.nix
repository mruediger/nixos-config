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
    '';
  };

  boot = {
    kernel.sysctl."vm.dirty_writeback_centisecs" = 6000;
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=75
      STOP_CHARGE_THRESH_BAT0=90
      START_CHARGE_THRESH_BAT1=75
      STOP_CHARGE_THRESH_BAT1=90
    '';
  };
}
