{ pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    devenv
    unstable.claude-code
    unstable.antigravity
    unstable.antigravity-cli
    unstable.flutter
    difftastic
  ];
}
