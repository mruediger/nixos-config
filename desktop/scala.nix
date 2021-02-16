{ pkgs, ...}:
{
  environment.systemPackages = with pkgs ;[
    scala
    sbt
    metals
  ];
}
