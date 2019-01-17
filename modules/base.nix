{ config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  services.fstrim.enable = true;
  services.timesyncd.enable = true;

  i18n = {
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  users = {
    extraUsers = {
      bag = {
        home = "/home/bag";
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel" "networkmanager" "input" "video" "sway"];
      };
    };
  };

  security = {
    sudo = {
      enable = true;
    };
  };
}
