{ pkgs, ... }:
{
  services.dbus.packages = [ pkgs.gcr ];
  services.gnome.gnome-keyring.enable = true;

  home-manager.sharedModules = [
    ({ ... }: {
      programs.password-store = {
        enable = true;
        package = pkgs.pass.override { waylandSupport = true; };
      };

      programs.gpg = {
        enable = true;
        settings = {
          keyserver = "hkps://keys.openpgp.org";
        };

        mutableKeys = false;
        mutableTrust = true;
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = "gnome3";
        enableScDaemon = true;
        grabKeyboardAndMouse = false;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
        '';
      };
    })
  ];

}
