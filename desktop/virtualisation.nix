{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
  };

  users.extraUsers.bag.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [ virtviewer virtmanager ];
}
