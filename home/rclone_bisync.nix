{ pkgs, lib, config, ... }:
let
  mkService = path1: path2: {
    Service = {
      Type = "simple";
      Environment = "PATH=/run/wrappers/bin";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone bisync ${path1} ${path2} --exclude ".git/**"
      '';
    };
  };

  mkTimer = unit: {
    Timer = {
      # 5 minutes after boot
      OnBootSec = "5m";
      # 5 minutes after last finished
      OnUnitInactiveSec = "5m";
      # run once when the timer is started
      Unit = "${unit}";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
in
{
  systemd.user.services = {
    rclone-bisync-doc = mkService "${config.home.homeDirectory}/doc" "nextcloud_blueboot:/Documents";
  };

  systemd.user.timers = {
    rclone-bisync-doc = mkTimer "rclone-bisync-doc.service";
  };
}
