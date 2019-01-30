{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    gcc # cgo dependency
  ];

  environment.variables = {
    GOPATH="$HOME/src/go";
    PATH="$PATH:$GOPATH/bin";
  };
}
