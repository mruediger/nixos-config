{ pkgs, lib, config, ... }:
let
  wrapped = pkgs.writeScriptBin "emacs" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.emacs}/bin/emacs --eval "(setq user-emacs-directory ${toString ./.})"
  '';
in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      emacs = pkgs.emacs.override {
        withGTK2 = false;
        withGTK3 = false;
        withXwidgets = false;
      };
    };
  };

  environment.systemPackages = with pkgs; [
#    wrapped
    emacs
    ledger
  ];
}
