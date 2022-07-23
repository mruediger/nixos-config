{ pkgs, lib, config, ... }:
{

  services.emacs = {
    package = with pkgs; ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages (epkgs: with epkgs; [
      use-package
      moody
      flycheck
      go-mode
      gotest
      lsp-mode
      magit
      nix-mode
      org
      origami
      solarized-theme
      sudo-edit
      terraform-mode
      which-key
      yaml-mode
      jsonnet-mode
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
  ];
}
