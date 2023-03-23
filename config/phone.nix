{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go-mtpfs
  ];

  programs.adb.enable = true;
  users.users.bag.extraGroups = ["adbusers"];
}
