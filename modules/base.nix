{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc
    file
    iotop
    jq
    ncdu
    pigz
    psmisc
    psutils
    pv
    screen
    sysfsutils
    unzip
    usbutils
    wget
    sshfs
    nmon
    sysstat
    mtr
    htop
    mprime
    pciutils
    usbutils
  ];

  time.timeZone = "Europe/Berlin";
  services.timesyncd.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.keyMap = "neo";
}
