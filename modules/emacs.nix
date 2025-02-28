{ pkgs, emacs-version, ... }:
{

  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-version).emacsWithPackages (epkgs: with epkgs; [
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

    nodePackages.bash-language-server
    nodePackages.yaml-language-server

    unstable.rust-analyzer

    direnv

    offlineimap
    notmuch
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      iosevka
    ];
  };
}
