{ pkgs, ... }:
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
{
  environment.systemPackages = [
    nixpkgs.latest.rustChannels.stable.rust
    nixpkgs.latest.rustChannels.stable.rust-src
  ];

  environment.variables = {
    PATH = ["$HOME/.cargo/bin"];
  };

}
