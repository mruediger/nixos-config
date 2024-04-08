{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go-mtpfs
    ausweisapp
  ];

  programs.adb.enable = true;
  users.users.bag.extraGroups = [ "adbusers" ];

  networking.firewall.allowedUDPPorts = [ 24727 ];
}
