{ pkgs, ...}:
{

  environment.systemPackages = [
    pkgs.devenv
    pkgs.claude-code
  ];
}
