{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go-mtpfs
    ausweisapp
    android-tools
  ];

  programs.adb.enable = true;
  users.users.bag.extraGroups = [ "adbusers" ];

  networking.firewall.allowedUDPPorts = [ 24727 ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
