{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    uv
    pyright
    (python3.withPackages (python-pkgs: with python-pkgs ;[
      ruamel-yaml
      systemd-python
    ]))
  ];

  # make uv work (suppor non-nix executables: https://nix.dev/permalink/stub-ld)
  programs.nix-ld.enable = true;
}
