{ pkgs, lib, config, ... }:
{

  services.emacs = {
    package = pkgs.emacsPgtkGcc;
    enable = true;
    defaultEditor = true;
  };

  nixpkgs.overlays = [
    (import (fetchTarball { url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz; }))
  ];



  environment.systemPackages = with pkgs; [
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

    gopls # lsp go
    rls   # rust lsp
    terraform-ls
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    rnix-lsp

    fira-code
    roboto-mono
  ];


}
