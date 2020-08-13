{ pkgs, ...}:
{
  environment.systemPackages = with pkgs ;[
    scala
    sbt
    jdk11
    metals
  ];
}
