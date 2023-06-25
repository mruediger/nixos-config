{ pkgs, lib, config, ... }:
{
  services.emacs = {
    package = with pkgs; ((emacsPackagesFor emacs-unstable-pgtk).emacsWithPackages (epkgs: with epkgs; [
      corfu
      go-mode
      gotest
      moody
      solarized-theme
      terraform-mode
      which-key
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

  programs = {
    bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}
