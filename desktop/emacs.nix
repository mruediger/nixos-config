{ pkgs, lib, config, ... }:
{

  environment.systemPackages = with pkgs; [
    (emacs.override { withGTK3 = true; })
    ledger
    hledger
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.de
    multimarkdown
    imagemagick # for image-dired
  ];
}
