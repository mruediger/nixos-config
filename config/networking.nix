{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    rclone
  ];

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 4713 7680 ];
    };
    wireguard.interfaces = {
      peers = [{
        publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
        allowedIPs = [ "10.42.42.0/24" ];
        endpoint = "blueboot.org:51820";
        persistentKeepalive = 25;
      }];
    };
  };

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

  services.resolved = {
    enable = true;
    domains = [
      "local"
    ];
    fallbackDns = [
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };

  # enable with systemctl --user add-wants default.targed rclone@foo.service
  systemd.user.services."rclone@" = {
    path = [ "/run/wrappers" ]; # use fusermount wrapper
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount %I:/ %h/rclone/%I
      '';
    };
  };
}
