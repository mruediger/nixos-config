{ pkgs, ... }:
let
  credentials = import ../crypt/nextcloud.nix;

  mkService = path1: path2: url: {
    Unit = {
      Description = "Auto sync Nextcloud: ${path1} ${path2}";
      After = "network-online.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -s -u ${credentials.blueboot.username} -p ${credentials.blueboot.password} --path ${path1} ${path2} ${url}";
      TimeoutStopSec = "180";
      KillMode = "process";
      KillSignal = "SIGINT";
    };
    Install.WantedBy = [ "multi-user.target" ];
  };

  mkTimer = {
    Unit.Description = "Automatic sync files with Nextcloud";
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install.WantedBy = [ "multi-user.target" "timers.target" ];
  };
in
{
  environment.systemPackages = with pkgs; [
    nextcloud-client
  ];

  home-manager.sharedModules = [
    ({ config, lib, ... }: {
      systemd.user = {
        services = {
          nc-sync-doc = mkService "Documents" "${config.home.homeDirectory}/doc" "https://cloud.blueboot.org";
          nc-sync-books = mkService "Books" "${config.home.homeDirectory}/media/books" "https://cloud.blueboot.org";
          nc-sync-norg = mkService "org" "${config.home.homeDirectory}/org" "https://cloud.blueboot.org";
        };
        timers = {
          nc-sync-doc = mkTimer;
          nc-sync-books = mkTimer;
          nc-sync-norg = mkTimer;
        };
        startServices = true;
      };
      home.activation.createBooksDirectory = let
        mkdir = (dir: ''[[ -L "${dir}" ]] || run mkdir -p $VERBOSE_ARG "${dir}"'');
      in lib.hm.dag.entryAfter [ "writeBoundary" ]
        (mkdir "${config.home.homeDirectory}/media/books");
    })
  ];
}
