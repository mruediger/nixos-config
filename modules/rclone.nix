{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rclone
  ];

  home-manager.sharedModules = [
    ({ lib, pkgs, config, ... }:
      let
        mkRcloneMountService = environment:
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
        services = [
            "nextcloud_blueboot"
            "nextcloud_darksystem"
            "gdrive_blueboot"
            "gdrive_justwatch"
            "gdrive_n96"
            "onedrive"
            "dropbox"
        ];
        directories = map (v: "${config.home.homeDirectory}/rclone/${v}") services;

        mkRcloneBiSyncService = remote: remote_path: local_path: {
          Unit = {
            Description = "RClone bisync: ${remote}:${remote_path} ${local_path}";
            After = "network-online.target";
          };
          Service = {
            Type = "simple";
            ExecStart = ''
              ${pkgs.rclone}/bin/rclone bisync ${remote}:${remote_path} ${local_path} --compare size,modtime
            '';
          };
          Install.WantedBy = ["multi-user.target"];
        };

        mkTimer = {
          Unit.Description = "RClone bisync timer";
          Timer = {
            OnBootSec = "5min";
            OnUnitActiveSec = "5min";
          };
          Install.WantedBy = [ "multi-user.target" "timers.target" ];
        };
      in
      {
        systemd.user = {
          services = builtins.listToAttrs (map mkRcloneMountService services) // {
            rc-bisync-org = mkRcloneBiSyncService "nextcloud_blueboot" "org" "${config.home.homeDirectory}/org";
            rc-bisync-doc = mkRcloneBiSyncService "nextcloud_blueboot" "Documents" "${config.home.homeDirectory}/doc";
            rc-bisync-books = mkRcloneBiSyncService "nextcloud_blueboot" "Books" "${config.home.homeDirectory}/media/books";
          };
          timers = {
            rc-bisync-org = mkTimer;
            rc-bisync-doc = mkTimer;
            rc-bisync-books = mkTimer;
          };
          startServices = true;
        };
        home.activation.createRcloneDirectories = let
          mkdir = (dir: ''[[ -L "${dir}" ]] || run mkdir -p $VERBOSE_ARG "${dir}"'');
        in lib.hm.dag.entryAfter [ "writeBoundary" ]
          (lib.strings.concatMapStringsSep "\n" mkdir directories);
      })
  ];
}
