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

  services.timesyncd.enable = true;
  console.keyMap = "neo";
}
