{ pkgs, inputs, ... }:
{

  environment.systemPackages = with pkgs; [
    unstable.claude-code
    unstable.antigravity-ide
    unstable.antigravity-cli
  ];

  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
  };
}
