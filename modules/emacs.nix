{ pkgs, lib, config, ... }:
let
  wrapped = pkgs.writeScriptBin "emacs" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.emacs}/bin/emacs --eval "(setq user-emacs-directory ${toString ./.})"
  '';
in
{
  environment.systemPackages = with pkgs; [
    wrapped
    emacs
    ledger
  ];
}
