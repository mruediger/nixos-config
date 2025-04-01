{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    maven
    jdk
    jdt-language-server
    spring-boot-cli
    gradle
  ];

}
