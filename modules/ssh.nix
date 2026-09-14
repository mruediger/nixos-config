{ ... }:
{
  programs.ssh = {
    startAgent = true;
  };

  home-manager.sharedModules = [
    ({ ... }: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
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
          "*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            Compression = false;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            HashKnownHosts = false;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
        };
      };
    })
  ];
}
