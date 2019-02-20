{ pkgs, lib, config, ... }:
let
  wrapped = pkgs.writeScriptBin "emacs" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.emacs}/bin/emacs --eval "(setq user-emacs-directory ${toString ./.})"
  '';
in
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
