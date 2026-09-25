{ pkgs, emacs-version, ... }:
{
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-version).emacsWithPackages
      (epkgs: [ epkgs.treesit-grammars.with-all-grammars ]))

    mermaid-cli
    silver-searcher # for ag.el
    ledger
    hledger
    beancount_2
    fava
    (aspellWithDicts ( dicts: with dicts; [ en en-computers en-science de ]))
    multimarkdown
    (rWrapper.override { packages = with rPackages; [ ggplot2 ]; })

    imagemagick # for image-dired

    gopls
    terraform-ls

    bash-language-server
    yaml-language-server

    jsonnet-language-server

    rust-analyzer

    offlineimap
    notmuch

    gnuplot
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
      iosevka
    ];
  };

  environment.variables.EDITOR = "emacsclient";
}
