{ pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    devenv
    unstable.claude-code
    unstable.gemini-cli
    unstable.antigravity
    unstable.flutter
    difftastic
  ];
}
