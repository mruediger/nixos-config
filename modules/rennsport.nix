{ pkgs, ... }:
{
  services.tailscale = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.zulip
  ];

  environment.variables = {
    GONOPROXY ="gitlab.com/rennsport/*";
    GONOSUMDB="gitlab.com/rennsport/*";
    GOPRIVATE="gitlab.com/rennsport/*";
  };
}
