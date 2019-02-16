{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    go-mtpfs
  ];
}
