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
  systemd.user.services = builtins.listToAttrs (map mkService [
    "nextcloud_blueboot"
    "nextcloud_darksystem"
    "gdrive_blueboot"
    "gdrive_justwatch"
    "gdrive_n96"
    "onedrive"
  ]);
}
