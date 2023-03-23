{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go_1_18
    gcc # cgo dependency
    godef
    gotools
    gopls
  ];

  environment.variables = {
    GOPATH = "$HOME/src/go";
    PATH   = ["$GOPATH/bin"];
  };
}
