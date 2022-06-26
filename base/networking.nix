{ pkgs, ... }:
{
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  services.avahi = {
    enable = true;
    ipv6 = true;
    nssmdns = true;
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
