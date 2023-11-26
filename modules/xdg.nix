{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = [
        "gtk"
      ];
    };
  };

  home-manager.sharedModules = [
    ({ config, ... }: {
      xdg = {
        userDirs = {
          enable = true;
          desktop = "${config.home.homeDirectory}/";
          documents = "${config.home.homeDirectory}/doc";
          templates = "${config.home.homeDirectory}/doc/templates";
          download = "${config.home.homeDirectory}/downloads";
          music = "${config.home.homeDirectory}/media/music";
          pictures = "${config.home.homeDirectory}/media/pictures";
          videos = "${config.home.homeDirectory}/media/videos";
          publicShare = "${config.home.homeDirectory}/public";
        };
      };
    })
  ];
}
