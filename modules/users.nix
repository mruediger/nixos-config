{ ... }:
{
  users.extraUsers.bag = {
    description = "Mathias Rüdiger";
    home = "/home/bag";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB09ouGKRRbYP5ZpZ5wYgfKHnopafi+ppzQn+3AMwq4t bag@josephine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFZoyPLGIlSzI5zA8MLvLM3P2rEUPAtgXYFhv0Y+8Nd bag@farting-unicorn"
    ];
  };

  security = {
    sudo = {
      enable = true;
    };
  };

  home-manager.users.bag = { };
}
