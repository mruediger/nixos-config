{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    uv
    pyright
    (python3.withPackages (python-pkgs: with python-pkgs ;[
      ruamel-yaml
      systemd
    ]))
  ];
}
