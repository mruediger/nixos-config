{ pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    devenv
    unstable.claude-code
    unstable.antigravity-ide
    unstable.antigravity-cli
    unstable.flutter
    difftastic
    nodejs
  ];
}
