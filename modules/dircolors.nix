{ ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      programs.dircolors = {
        enable = true;
        enableBashIntegration = true;
      };
    })
  ];
}
