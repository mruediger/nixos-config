{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    godef
    gotools
    gopls
    gcc # cgo dependency
  ];

  environment.variables = {
    GOPATH = "$HOME/src/go";
    PATH = [ "$GOPATH/bin" ];
  };
}
