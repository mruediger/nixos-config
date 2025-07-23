{ pkgs, lib, ... }:
{
  services.tailscale = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.zulip
    pkgs.grafana-loki
  ];

  environment.variables = {
    GONOPROXY ="gitlab.com/rennsport/*";
    GONOSUMDB="gitlab.com/rennsport/*";
    GOPRIVATE="gitlab.com/rennsport/*";
  };

  programs.git.config.includeIf = {
    "gitdir:~/src/rennsport/" = {
      path = "gitconfig_rennsport";
    };
  };

  environment.etc.gitconfig_rennsport.text = lib.generators.toGitINI {
    gitlab.user = "mruediger_rennsport";
  };

  home-manager.sharedModules = [
    ({ ... }: {
      programs.ssh.matchBlocks."rennsport.gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/rennsport_gitlab";
      };
    })
  ];

}
