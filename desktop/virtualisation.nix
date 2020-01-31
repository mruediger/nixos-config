{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
  };

  users.extraUsers.bag.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [ virtviewer virtmanager ];
  environment.systemPackages = with pkgs; [
    virtviewer
    virtmanager
    vagrant
    spice-vdagent
  ];

  services.nfs.server.enable = true;

  # for vagrant nfs
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

}
