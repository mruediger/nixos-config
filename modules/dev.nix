{ pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    devenv
    unstable.flutter
    difftastic
    nodejs
  ];
}
