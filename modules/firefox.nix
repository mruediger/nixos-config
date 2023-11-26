{ pkgs, ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      programs.browserpass = {
        enable = true;
        browsers = [
          "chrome"
          "chromium"
          "firefox"
        ];
      };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
        profiles.main =
          {
            id = 0;
            isDefault = true;
          };
      };
    })
  ];
}
