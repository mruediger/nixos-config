{ pkgs, lib, config, ... }:
{

  environment.systemPackages = with pkgs; [
    emacsPgtk
    ledger
    hledger
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.de
    multimarkdown
    imagemagick # for image-dired
  ];


  nixpkgs.overlays = [
    (import (builtins.fetchTarball { url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz; }))
  ];
}
