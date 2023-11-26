{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.go_1_21
    unstable.godef
    unstable.gotools
    unstable.gopls

    gcc # cgo dependency
  ];

  environment.variables = {
    GOPATH = "$HOME/src/go";
    PATH = [ "$GOPATH/bin" ];
  };
}
