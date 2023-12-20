{ pkgs, lib, config, ... }:
{
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-unstable-pgtk).emacsWithPackages (epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
    ]))

    silver-searcher # for ag.el
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

    unstable.gopls
    unstable.terraform-ls
    unstable.rnix-lsp

    nodePackages.bash-language-server
    nodePackages.yaml-language-server

    unstable.rust-analyzer

    direnv

    offlineimap
    notmuch
  ];
}
