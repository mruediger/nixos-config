{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    btrfs-progs
    btrfs-snap
    btrfs-list
    btrfs-heatmap
    btrfs-assistant
  ];

  services.btrfs.autoScrub = {
    enable = config.networking.hostName == "josephine";
    interval = "weekly";
  };
}
