{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    uv
    pyright
    ty
  ];

  # make uv work (suppor non-nix executables: https://nix.dev/permalink/stub-ld)
  programs.nix-ld.enable = true;
}
