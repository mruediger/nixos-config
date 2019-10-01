{ pkgs, lib, config, ... }:
{

  environment.systemPackages = with pkgs; [
    (emacs.override { withGTK3 = true; })
    ledger
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.de
    multimarkdown
  ];
}
