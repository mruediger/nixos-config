{ ... }:
{
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    ipv6 = true;
    nssmdns = true;
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };
}
