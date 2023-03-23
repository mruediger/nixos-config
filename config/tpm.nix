{ pkgs, ... }:
{
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
  };

  #todo gnupg-pkcs11-scd.conf
  #todo gpg-agent.conf
  #stuck at openssl pkcs11 enigne (https://www.evolware.org/?p=597)

  environment.systemPackages = with pkgs; [
    gnupg-pkcs11-scd
  ];
}
