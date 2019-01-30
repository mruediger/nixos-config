{ pkgs, config, ... }:
{
  nixpkgs.config = {
    oraclejdk.accept_license = true;
  };

  environment.systemPackages = with pkgs; [
    oraclejdk8
  ];
}
