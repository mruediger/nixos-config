{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rclone
  ];

  home-manager.sharedModules = [
    ({ lib, pkgs, config, ... }:
      let
        mkRcloneService = environment:
          lib.nameValuePair "rclone-${environment}" {
            Service = {
              Type = "simple";
              Environment = "PATH=/run/wrappers/bin";
              ExecStart = ''
                ${pkgs.rclone}/bin/rclone mount ${environment}:/ ${config.home.homeDirectory}/rclone/${environment}
              '';
            };
            Install = {
              WantedBy = [ "default.target" ];
            };
          };

        mkSyncService = path1: path2: {
          Service = {
            Type = "simple";
            Environment = "PATH=/run/wrappers/bin";
            ExecStart = ''
              ${pkgs.rclone}/bin/rclone bisync ${path1} ${path2} --exclude ".git/**"
            '';
          };
        };

        mkSyncTimer = unit: {
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
        systemd.user.services = builtins.listToAttrs
          (map mkRcloneService [
            "nextcloud_blueboot"
            "nextcloud_darksystem"
            "gdrive_blueboot"
            "gdrive_justwatch"
            "gdrive_n96"
            "onedrive"
          ]) // { };
      })
  ];
}
