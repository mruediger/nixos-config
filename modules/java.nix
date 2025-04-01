{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    maven
    jdk
  ];

}
