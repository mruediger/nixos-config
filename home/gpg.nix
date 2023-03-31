{ pkgs, ... }:
{
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
  };
}
