{ pkgs, lib, config, ... }:
{
  services.emacs = {
    package = with pkgs; ((emacsPackagesFor emacsPgtk).emacsWithPackages (epkgs: with epkgs; [
      corfu
      direnv
      flycheck
      go-mode
      gotest
      highlight-indent-guides
      jsonnet-mode
      ledger-mode
      lsp-mode
      lsp-ui
      magit
      moody
      nix-mode
      notmuch
      org
      solarized-theme
      sudo-edit
      terraform-mode
      use-package
      which-key
      yasnippet
      yasnippet-snippets
    ]));
    enable = true;
    defaultEditor = true;
  };

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

    unstable.gopls
    unstable.terraform-ls
    unstable.rnix-lsp

    nodePackages.bash-language-server
    nodePackages.yaml-language-server

    direnv

    offlineimap
    notmuch
  ];

  fonts = {
    fonts = with pkgs; [
      roboto
      iosevka
      font-awesome
      inconsolata
    ];
  };

  programs = {
    bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}
