{ pkgs, ... }:
{
  time.hardwareClockInLocalTime = true;
  boot.supportedFilesystems = [ "ntfs" ];

  environment.systemPackages = with pkgs; [
    dos2unix
  ];
}
