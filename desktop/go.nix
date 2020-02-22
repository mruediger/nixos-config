{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go
    gcc # cgo dependency
    godef
    goimports
  ];

  environment.variables = {
    GOROOT = [ "${pkgs.go.out}/share/go" ];
    GOPATH = "$HOME/src/go";
    PATH   = ["$GOPATH/bin"];
  };
}
