{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.claude-code
    unstable.antigravity-ide
    unstable.antigravity-cli
  ];
}
