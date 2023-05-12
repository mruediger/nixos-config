{ pkgs, ... }:
{
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
    pinentryFlavor = "curses";
    enableScDaemon = true;
    grabKeyboardAndMouse = false;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
