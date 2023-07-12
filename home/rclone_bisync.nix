{}:
let
  mkService = name: path1: path2:
    lib.nameValuePair "bisync-${name}" {
      Service = {
        Type = "simple";
        Environment = "PATH=/run/wrappers/bin";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone bisync ${path1} ${path2} --exclude ".git/**"
        '';
      };
    };
in
{
  systemd.user.services = {
    rclone-bisync-doc = mkService "${config.home.homeDirectory}/doc" "nextcloud_blueboot:/Documents";
  };
}
