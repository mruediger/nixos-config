{ pkgs, ... }:
let
  moz_overlay = import (fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
{
  environment.systemPackages = [
    (pkgs.latest.rustChannels.stable.rust.override { extensions = [ "rust-src" "rls-preview" "rust-analysis" "rustfmt-preview" ];})
  ];

  environment.variables = {
    PATH = ["$HOME/.cargo/bin"];
  };

}
