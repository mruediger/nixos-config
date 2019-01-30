{ config, ... }:

{
  users.extraUsers.bag.extraGroups = ["docker"];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
