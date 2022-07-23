{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
  };

  users.extraUsers.bag.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virt-viewer
    virtmanager
    vagrant
    bridge-utils
    spice-vdagent
  ];

  services.nfs.server.enable = true;

  # for vagrant nfs
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
    ip46tables -I INPUT 1 -i vboxbr+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  networking.firewall.checkReversePath = false;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  users.extraUsers.bag.extraGroups = ["docker"];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
