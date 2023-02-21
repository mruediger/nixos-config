{ pkgs, lib, config, ... }:
{
  services.emacs = {
    package = with pkgs; ((emacsPackagesFor emacsPgtk).emacsWithPackages (epkgs: with epkgs; [
      corfu
      direnv
      edit-server
      flycheck
      go-mode
      gotest
      jsonnet-mode
      ledger-mode
      lsp-mode
      lsp-ui
      magit
      moody
      nix-mode
      org
      origami
      solarized-theme
      sudo-edit
      terraform-mode
      use-package
      which-key
      yaml-mode
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

    gopls # lsp go
    rls   # rust lsp
    terraform-ls
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    rnix-lsp

    direnv
  ];
  fonts = {
    fonts = with pkgs; [
      iosevka
    ];
  };

  programs = {
    bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };
}
