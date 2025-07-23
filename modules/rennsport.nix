{ pkgs, ... }:
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
