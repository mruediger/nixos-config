{ pkgs, emacs-version, ... }:
{

  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-version).emacsWithPackages (epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      ag
      company
      consult
      copy-as-format
      csv-mode
      diff-hl
      direnv
      doom-modeline
      eglot-java
      elysium
      flycheck
      forge
      gcmh
      git-link
      gptel
      gruvbox-theme
      highlight-indent-guides
      jsonnet-mode
      ledger-mode
      magit
      magit-todos
      marginalia
      nerd-icons-dired
      nix-mode
      nov
      ob-async
      orderless
      org-tree-slide
      pass
      pdf-tools
      rego-mode
      sudo-edit
      terraform-mode
      typst-ts-mode
      use-package-chords
      vertico
      which-key
      xkcd
      yasnippet
      yasnippet-snippets
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
