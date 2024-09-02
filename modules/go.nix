{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go_1_21
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
