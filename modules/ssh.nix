{ ... }:
{
  programs.ssh = {
    startAgent = true;
  };

  home-manager.sharedModules = [
    ({ ... }: {
      programs.ssh = {
        enable = true;

        matchBlocks = {
          "blueboot.org" = {
            user = "bag";
            identityFile = "~/.ssh/blueboot";
          };

          "github.com" = {
            user = "mruediger";
            identityFile = "~/.ssh/github";
          };

          "gitlab.com" = {
            user = "mruediger";
            identityFile = "~/.ssh/gitlab";
          };
        };
      };
    })
  ];
}
