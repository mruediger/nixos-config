{ ... }:
{
  users.extraUsers.bag = {
    description = "Mathias Rüdiger";
    home = "/home/bag";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsvZoC8Cl2by+hHJWhZYPLKGfM50Y6OgUXehSwFGVt1 bag@josephine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+DjDnJkX9xDJAY6ciUUxO2W0413w1Bvr8oQU2ufpNs bag@farting-unicorn"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgc+zDAB4Y1HcvewdiKdKlcRo2wf4iO5aWIYab7EroV bag@butterfly"
    ];
  };

  security = {
    sudo = {
      enable = true;
    };
  };

  home-manager.users.bag = { };
}
