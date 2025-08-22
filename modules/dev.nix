{ pkgs, ...}:
{

  environment.systemPackages = [
    pkgs.unstable.devenv
    pkgs.unstable.claude-code
  ];
}
