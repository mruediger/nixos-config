{ pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    rclone
  ];

  # enable with systemctl --user add-wants default.targed rclone@foo.service
  systemd.user.services."rclone@" = {
    path = [ "/run/wrappers" ]; # use fusermount wrapper
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount %I:/ %h/rclone/%I
      '';
    };
  };
}
