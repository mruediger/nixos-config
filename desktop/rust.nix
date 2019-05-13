{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    latest.rustChannels.stable.rust
  ];
}
