{ pkgs, ... }:
{
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
        search.engines =
          {
            "Wikipedia (de)" = {
              urls = [{
                template = "https://de.wikipedia.org/wiki/Special:Search";
                params = [
                  { name = "search"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "wp" "@wp" ];
            };


            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = false;
            "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            "Amazon.com".metaData.hidden = true;
            "Wikipedia (en)".metaData.alias = "wpe";
          };
      };
  };
}
