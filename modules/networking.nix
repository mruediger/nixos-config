{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 4713 7680 ];
    };
    wireguard.interfaces = {
      wg0 = {
        peers = [{
          publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
          allowedIPs = [ "10.42.42.0/24" ];
          endpoint = "blueboot.org:51820";
          persistentKeepalive = 25;
        }];
      };
    };
  };

  services.avahi = {
    enable = true;
    ipv6 = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    settings.Resolve = {
      FallbackDNS = [
        "1.1.1.1"
        "2606:4700:4700::1111"
      ];
    };
  };
}
