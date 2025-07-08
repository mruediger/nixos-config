{ ... }:
{

  services.tailscale = {
    enable = true;
  };

  environment.variables = {
    GONOPROXY ="gitlab.com/rennsport/*";
    GONOSUMDB="gitlab.com/rennsport/*";
    GOPRIVATE="gitlab.com/rennsport/*";
  };
}
