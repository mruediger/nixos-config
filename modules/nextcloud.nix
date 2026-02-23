{ pkgs, ... }:
let
  environment.systemPackages = [ pkgs.nextcloud-client ];

  credentials = import ../crypt/nextcloud.nix;

  mkService = server_url: remote_folder: source_dir: {
    Unit = {
      Description = "Auto sync NextCloud: ${server_url}/${remote_folder} ${source_dir}";
      After = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd --user ${credentials.blueboot.username} --password ${credentials.blueboot.password} --path ${remote_folder} ${source_dir} ${server_url}";
      TimeoutStopSec = "180";
      KillMode = "process";
      KillSignal = "SIGINT";
    };
    Install.WantedBy = [ "multi-user.target" ];
  };

  mkTimer = {
    Unit.Description = "Automatic sync files with NextCloud";
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install.WantedBy = [ "multi-user.target" "timers.target" ];
  };
in
{
  environment.systemPackages = with pkgs; [
    opencloud-desktop
  ];

  home-manager.users.bag = { config, ... }:{
    systemd.user = {
      services = {
        nc-sync-doc = mkService "https://cloud.blueboot.org"  "doc" "${config.home.homeDirectory}/doc";
        nc-sync-org = mkService "https://cloud.blueboot.org" "org" "${config.home.homeDirectory}/org";
        nc-sync-books = mkService "https://cloud.blueboot.org" "books" "${config.home.homeDirectory}/media/books";
      };
      timers = {
        nc-sync-doc = mkTimer;
        nc-sync-org = mkTimer;
        nc-sync-books = mkTimer;
      };
      startServices = true;
    };
  };
}
