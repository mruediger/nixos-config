{ pkgs, lib, config, ... }:
let
  mkService = environment:
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
in
{
  systemd.user.services = {
    rclone-nextcloud_blueboot = {
      Service = {
        Type = "oneshot";
        Environment = "PATH=/run/wrappers/bin";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone bisync nextcloud_blueboot: ${config.home.homeDirectory}/rclone/nextcloud_blueboot      '';
      };
    };
  } // (builtins.listToAttrs (map mkService [
    "nextcloud_darksystem"
    "gdrive_blueboot"
    "gdrive_justwatch"
    "gdrive_n96"
    "onedrive"
  ]));


  systemd.users.timers.rclone-nextcloud_blueboot = {
    Timer = {
      Unit = "rclone-nextcloud_blueboot.service";
      OnActiveSec = 300;
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
