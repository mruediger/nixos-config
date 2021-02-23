{ pkgs, lib, config, ... }:
{
  nixpkgs.overlays = [
    (import (fetchTarball { url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz; }))
  ];

  environment.systemPackages = with pkgs; [
    #    emacsPgtk
    emacs
    ledger
    hledger
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.de
    multimarkdown
    (rWrapper.override { packages = with rPackages; [ ggplot2 ]; })

    imagemagick # for image-dired
  ];


}
