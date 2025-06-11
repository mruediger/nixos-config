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
            user = "bag";
            identityFile = "~/.ssh/github";
          };

          "gitlab.com" = {
            user = "bag";
            identityFile = "~/.ssh/gitlab";
          };
        };
      };
    })
  ];
}
