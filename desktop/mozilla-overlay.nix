{ config, pkgs, ... }:

let
  mozilla_overlay = import ("${builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz}");
in {

  environment.systemPackages = with pkgs; [
    #latest.firefox-nightly-bin
    VidyoDesktop
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      mozilla_overlay
    ];
  };
}
