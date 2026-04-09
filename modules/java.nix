{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    maven
    jdk25
    jdt-language-server
    spring-boot-cli
    gradle
  ];

}
