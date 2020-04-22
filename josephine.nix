{ config, pkgs, ... } @ args:

let
  hardwareTarball = fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) { config.allowUnfree = true; };
in
{
  imports = [
    ./base
    (import ./desktop ({unstable = unstable;} // args ))
  ];

  networking.hostName = "josephine";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  };

  services.logind = {
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };

  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

#  networking.wireguard.interfaces = {
#    wg0 = {
#      ips = [ "10.42.42.2/32" ];
#      privateKeyFile = "${toString ./.}" + "/wireguard-blueboot.key";
#      peers = [{
#        publicKey = "uk0WkHHW02ExU/TYXbCRHJQX+R7mXhcCygz/1DTxOmI=";
#        allowedIPs = [ "10.42.42.0/24" ];
#        endpoint = "blueboot.org:51820";
#        persistentKeepalive = 25;
#      }];
#    };
#  };

#  nixpkgs.overlays = [
#    (import ./overlays/google-cloud-sdk.nix )
#    (import ./overlays/gotools.nix )
#  ];
}
