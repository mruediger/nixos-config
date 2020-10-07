{ pkgs, ... }:
let
  openconnect = pkgs.callPackage ../packages/openconnect.nix { openssl = null; };
in
{
  environment.systemPackages = with pkgs; [
    citrix_workspace
    openconnect
  ];

  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ../certificates/jira.gda.allianz
  ];
}
