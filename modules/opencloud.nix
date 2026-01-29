{ pkgs, config, ... }:
let
  credentials = import ../crypt/opencloud.nix;

  mkService = server_url: space_id: remote_folder: source_dir: {
    Unit = {
      Description = "Auto sync OpenCloud: ${server_url}/${remote_folder} ${source_dir}";
      After = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.opencloud-desktop}/bin/opencloudcmd --user ${credentials.blueboot.username} --token \"${credentials.blueboot.token}\" --remote-folder ${remote_folder} ${server_url} ${space_id} ${source_dir}";
      TimeoutStopSec = "180";
      KillMode = "process";
      KillSignal = "SIGINT";
    };
    Install.WantedBy = [ "multi-user.target" ];
  };

  mkTimer = {
    Unit.Description = "Automatic sync files with OpenCloud";
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
        oc-sync-doc = mkService "https://opencloud.blueboot.org" "space:c68b1361" "doc" "${config.home.homeDirectory}/doc";
        oc-sync-org = mkService "https://opencloud.blueboot.org" "space:c68b1361" "org" "${config.home.homeDirectory}/org";
        oc-sync-books = mkService "https://opencloud.blueboot.org" "space:c68b1361" "books" "${config.home.homeDirectory}/media/books";
      };
      timers = {
        oc-sync-doc = mkTimer;
        oc-sync-org = mkTimer;
        oc-sync-books = mkTimer;
      };
      startServices = true;
    };
  };
}
