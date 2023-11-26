{ ... }:
{
  home-manager.sharedModules = [
    ({ ... }: {
      prgrams.dircolors = {
        enable = true;
        enableBashIntegration = true;
      };
    })
  ];
}
