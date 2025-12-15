{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    btrfs-snap
    btrfs-list
    btrfs-heatmap
    btrfs-assistant
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };


}
