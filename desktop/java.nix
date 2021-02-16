{  pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jdk11
    gradle
    maven
  ];
}
